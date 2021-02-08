ARCH=x86_64

DIST=$(cat /etc/*-release | grep "^ID="|cut -d'=' -f2|sed 's/\"//g')
DIST_VERSION=$(cat /etc/*-release | grep "^VERSION_ID="|cut -d'=' -f2 | sed 's/[\"\.]//g')
if [[ $DIST == "fedora" ]]; then
    DIST="fc"
elif [[ $DIST == "ubuntu" ]];then 
    DIST="ub"
elif [[ $DIST == "centos" ]]; then
    DIST="co"
fi

BUILD_TYPE=${BUILD_TYPE:-dbg}
COMPILER=${COMPILER:-gcc}
COMPILER_VERSION=$(${COMPILER} --version | head -1 | perl -n -e'/\w+ ((\d+\.)+\d+)/ && print $1') 
COMPILER_ID=$(echo ${COMPILER_VERSION} | awk 'BEGIN {FS=".";} { printf $1$2 }')

export BINARY_TAG="${ARCH}-${DIST}${DIST_VERSION}-${COMPILER}${COMPILER_ID}-${BUILD_TYPE}"
export CMAKE_PREFIX_PATH=/home/aalvarez/Work/Projects/Elements/5.12/cmake
export CMAKE_PROJECT_PATH=/home/aalvarez/Work/Projects
export CMAKEFLAGS="-DCPACK_REMOVE_SYSTEM_DEPS=ON -DPYTHON_EXPLICIT_VERSION=3 -DCMAKE_USE_CCACHE=YES -DCMAKE_VERBOSE_MAKEFILE=YES"

export EDITOR=vim

export PATH="${PATH}:${HOME}/.local/bin"
export CONDA_BLD_PATH="/tmp/conda-bld"
export QT_QPA_PLATFORMTHEME=qt5ct

export RPM_PACKAGER="Alejandro Alvarez Ayllon <aalvarez@fedoraproject.org>"

