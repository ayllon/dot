# Editor
export EDITOR=vim

# Add .local/bin to the PATH
export PATH="${PATH}:${HOME}/.local/bin"

# sdkman
source "/home/alejandro.alvarez/.sdkman/bin/sdkman-init.sh"

# Tokens
source ~/.tokens

# Compiler
export CXX=$(which clang++-15)
export CC=$(which clang-15)

# Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/

# Verbose cmake
export VERBOSE=1
