# Editor
export EDITOR=vim

# Add .local/bin and scripts to the PATH
export PATH="${PATH}:${HOME}/.local/bin:${HOME}/source/repos/scripts/"

# sdkman
if [ -f "/home/alejandro.alvarez/.sdkman/bin/sdkman-init.sh" ]; then
    source "/home/alejandro.alvarez/.sdkman/bin/sdkman-init.sh"
fi

# Tokens
if [ -f ~/.tokens ]; then
    source ~/.tokens
fi

# Compiler
CLANGPP=$(which clang++ 2> /dev/null)
if [ $? -eq 0 ]; then
    export CXX="${CLANGPP}"
fi
CLANG=$(which clang 2> /dev/null)
if [ $? -eq 0 ]; then
    export CC="${CLANG}"
fi

# Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/

# Verbose cmake
export VERBOSE=1

# Rust
if [ -f "${HOME}/.cargo/env" ]; then
    . "${HOME}/.cargo/env"
fi
