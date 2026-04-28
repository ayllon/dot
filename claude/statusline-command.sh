#!/bin/bash
export GIT_OPTIONAL_LOCKS=0

# Read stdin (Claude passes JSON context)
input=$(cat)

# Get model name
model_name=""
if command -v jq > /dev/null 2>&1; then
    model_display=$(echo "$input" | jq -r '.model.display_name // empty' 2>/dev/null)
    if [ -n "$model_display" ]; then
        model_name=$(printf "\033[01;35m[%s]\033[00m " "$model_display")
    fi
fi

# Get current directory
dir=$(pwd)

# Get context usage and cost information
context_info=""
cost_info=""
if command -v jq > /dev/null 2>&1; then
    used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)

    if [ -n "$used_pct" ]; then
        # Convert to integer for comparison
        used_int=$(printf "%.0f" "$used_pct" 2>/dev/null || echo "0")

        # Color code based on usage: green < 50%, yellow < 80%, red >= 80%
        if [ "$used_int" -lt 50 ]; then
            context_info=$(printf " [\033[01;32m%s%%\033[00m]" "$used_pct")
        elif [ "$used_int" -lt 80 ]; then
            context_info=$(printf " [\033[01;33m%s%%\033[00m]" "$used_pct")
        else
            context_info=$(printf " [\033[01;31m%s%%\033[00m]" "$used_pct")
        fi
    fi

    # Estimate session cost from cumulative token counts
    # Pricing (USD per 1M tokens) varies by model tier; defaults to Sonnet pricing
    model_id=$(echo "$input" | jq -r '.model.id // empty' 2>/dev/null)
    total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0' 2>/dev/null)
    total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0' 2>/dev/null)
    cache_write=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0' 2>/dev/null)
    cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0' 2>/dev/null)

    if [ -n "$total_in" ] && [ "$total_in" != "0" -o "$total_out" != "0" ]; then
        # Select per-1M token prices based on model tier
        case "$model_id" in
            *haiku*)
                price_in="0.80"; price_out="4.00"; price_cache_write="1.00"; price_cache_read="0.08" ;;
            *opus*)
                price_in="15.00"; price_out="75.00"; price_cache_write="18.75"; price_cache_read="1.50" ;;
            *)
                # Default: Sonnet tier
                price_in="3.00"; price_out="15.00"; price_cache_write="3.75"; price_cache_read="0.30" ;;
        esac

        cost=$(awk -v ti="$total_in" -v to="$total_out" \
                   -v cw="$cache_write" -v cr="$cache_read" \
                   -v pi="$price_in" -v po="$price_out" \
                   -v pcw="$price_cache_write" -v pcr="$price_cache_read" \
            'BEGIN {
                cost = (ti / 1000000 * pi) + (to / 1000000 * po) \
                     + (cw / 1000000 * pcw) + (cr / 1000000 * pcr);
                printf "%.3f", cost
            }')

        cost_info=$(printf "\033[01;35m\$%s\033[00m " "$cost")
    fi
fi

# Get git info if in a git repo
git_info=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    # Get branch name
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

    # Get status indicators (skip optional locks for performance)
    status_output=$(git -c core.useBuiltinFSMonitor=false status --porcelain 2>/dev/null)

    # Check for various states
    untracked=""
    modified=""
    staged=""

    if echo "$status_output" | grep -q '^??'; then
        untracked="?"
    fi
    if echo "$status_output" | grep -q '^ M\|^AM\|^ T'; then
        modified="*"
    fi
    if echo "$status_output" | grep -q '^M\|^A\|^D\|^R\|^C'; then
        staged="+"
    fi

    # Check if ahead/behind remote
    ahead_behind=""
    upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
    if [ -n "$upstream" ]; then
        ahead=$(git rev-list --count HEAD@{upstream}..HEAD 2>/dev/null || echo "0")
        behind=$(git rev-list --count HEAD..HEAD@{upstream} 2>/dev/null || echo "0")

        if [ "$ahead" -gt 0 ]; then
            ahead_behind="↑${ahead}"
        fi
        if [ "$behind" -gt 0 ]; then
            ahead_behind="${ahead_behind}↓${behind}"
        fi
    fi

    # Build git info string with color
    indicators="${staged}${modified}${untracked}${ahead_behind}"
    if [ -n "$indicators" ]; then
        git_info=$(printf " (\033[01;31m%s\033[00m %s)" "$branch" "$indicators")
    else
        git_info=$(printf " (\033[01;32m%s\033[00m)" "$branch")
    fi
fi

# Build user@host prefix from PS1 style
user_host=$(printf "\033[01;32m%s@%s\033[00m:" "$(whoami)" "$(hostname -s)")

# Build and output the status line: model + cost + user@host + directory + git info + context usage
printf "%s%s%s\033[01;34m%s\033[00m%s%s" "$model_name" "$cost_info" "$user_host" "$dir" "$git_info" "$context_info"
