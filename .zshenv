# Editor
export EDITOR=vim

# Add .local/bin and scripts to the PATH
export PATH="${HOME}/.local/bin:${HOME}/projects/scripts/:${PATH}"

# sdkman
source "/home/alejandro.alvarez/.sdkman/bin/sdkman-init.sh"

# Tokens
source ~/.tokens

# Compiler
export CXX=$(which clang++-20)
export CC=$(which clang-20)

# Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/

# Verbose cmake
export VERBOSE=1

# Rust
. "$HOME/.cargo/env"
