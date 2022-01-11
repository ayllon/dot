# Architecture
ARCH=$(uname -m)

# OS
OS=$(uname -s | tr '[:upper:]' '[:lower:]')

if [[ -n "$CONDA_PREFIX" ]]; then
    DIST="conda_${OS}"
    VERSION_ID=$(conda --version | perl -n -e '/conda (\d+)/ && print $1')
elif [[ $OS == "linux" ]]; then
    source /etc/os-release

    if [[ $ID == "fedora" ]]; then
        DIST="fc"
    elif [[ $ID == "ubuntu" ]];then
        DIST="ub"
    elif [[ $ID == "centos" ]]; then
        DIST="co"
    fi
elif [[ $OS == "Darwin" ]]; then
    DIST="osx"
    VERSION_ID=$(sw_vers -productVersion | perl -n -e '/(\d+)\.(\d+)/ && print $1,$2')
else
    DIST="unknown"
fi

# Build type, default to debug
BUILD_TYPE=${BUILD_TYPE:-dbg}

# Compiler ID and version
CC=${CC:-gcc}

if [[ $CC == *"clang" ]]; then
    CC_VERSION=$(${CC} -dumpversion | perl -n -e '/(\d+)\.(\d+)/ && print $1,$2')
    CC_ID="clang"
else
    CC_VERSION=$(${CC} --version | head -1 | perl -n -e '/(\S+) \((.+)\) (\d+)\.(\d+)\./ && print $3,$4')
    CC_ID="gcc"
fi

# Build the binary tag
export BINARY_TAG="${ARCH}-${DIST}${VERSION_ID}-${CC_ID}${CC_VERSION}-${BUILD_TYPE}"

# Location of Elements and project
export CMAKE_PROJECT_PATH="${HOME}/Work/Projects"
export CMAKE_PREFIX_PATH="${CMAKE_PROJECT_PATH}/Elements/5.12/cmake"

# CMake flags
export CMAKEFLAGS="-DCPACK_REMOVE_SYSTEM_DEPS=ON -DCMAKE_USE_CCACHE=YES -DCMAKE_VERBOSE_MAKEFILE=YES -DELEMENTS_DETACHED_DEBINFO=OFF -DCMAKE_SUPPRESS_REGENERATION=ON"
if [[ $ID != "centos" || $VERSION_ID > 7 ]]; then
    export CMAKEFLAGS="$CMAKEFLAGS -DPYTHON_EXPLICIT_VERSION=3"
fi

if [[ $DIST == "conda"* ]]; then
    export CFITSIO_INSTALL_DIR="${CONDA_PREFIX}"
    export CMAKEFLAGS="$CMAKEFLAGS -DBoost_NO_BOOST_CMAKE=ON"
fi

which sphinx-build &> /dev/null
if [[ $? -ne 0 ]]; then
    export CMAKEFLAGS="$CMAKEFLAGS -DINSTALL_DOC=OFF -DUSE_SPHINX=OFF"
fi

# RPM
export RPM_PACKAGER="Alejandro Alvarez Ayllon <aalvarez@fedoraproject.org>"

# Secrets, if any
if [ -f "${HOME}/.tokens" ]; then
    source "${HOME}/.tokens"
fi

# Editor
export EDITOR=vim

# Add .local/bin to the PATH
export PATH="${PATH}:${HOME}/.local/bin"

# Build conda packages under /tmp
export CONDA_BLD_PATH="/tmp/conda-bld"

