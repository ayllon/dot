# Editor
export EDITOR=vim

# Add .local/bin and scripts to the PATH
export PATH="${PATH}:${HOME}/.local/bin:${HOME}/source/repos/scripts/"

# sdkman
if [ -f "/home/alejandro.alvarez/.sdkman/bin/sdkman-init.sh" ]; then
    source "/home/alejandro.alvarez/.sdkman/bin/sdkman-init.sh"
fi

# Tokens
source ~/.tokens

# Compiler
export CXX=$(which clang++)
export CC=$(which clang)

# Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/

# Verbose cmake
export VERBOSE=1

# Rust
. "$HOME/.cargo/env"
