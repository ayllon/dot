# Editor
export EDITOR=vim

# Add .local/bin to the PATH
export PATH="${PATH}:${HOME}/.local/bin"

# sdkman
source "/home/alejandro.alvarez/.sdkman/bin/sdkman-init.sh"

# Tokens
source ~/.tokens

# Compiler
export CXX=$(which g++-11)
export CC=$(which gcc-11)

# Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/

# Verbose cmake
export VERBOSE=1
