#!/bin/bash -e


VERSION="4.7.12"

verlte() {
    [  "$1" = "`echo -e "$1\n$2" | sort -V | head -n1`" ]
}

verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}


if [[ $# == 2 ]]; then
    CONDA_ROOT=$1
    VERSION=$2
elif [[ $# == 3 ]]; then
    # Starting conda v4.8, the repo path now contains the python version: 3.7 or 3.8. This codepath handles that
    # Could add more validation for version types, but we can also ignore here
    CONDA_ROOT=$1
    VERSION=$2
    PY_VERSION=$3
elif [[ $# == 1 ]]; then
    CONDA_ROOT=$1
else
    echo "Please specify the desired conda installation path as the only argument."
    exit 1
fi

# Get miniconda if it doesn't exist.
if [[ ! -f $CONDA_ROOT/installed ]]; then
    echo "Installing Conda version $VERSION to $CONDA_ROOT."
    if ! which sudo > /dev/null; then
        [[ ! -d $CONDA_ROOT ]] && mkdir $CONDA_ROOT
    else
        [[ ! -d $CONDA_ROOT ]] && sudo mkdir $CONDA_ROOT
        [[ -z $USER ]] && USER=root
        sudo chown $USER $CONDA_ROOT
    fi
    if [[ "$(uname)" == "Darwin" ]]; then
        if [[ "$(uname -m)" == "x86_64" ]]; then
            OS_VERSION="MacOSX-x86_64"
        else
            OS_VERSION="MacOSX-arm64"
        fi
    else
        OS_VERSION="Linux-x86_64"
    fi
    # Need a second check to see if we need to write py37/py38 into the URL for conda versions > 4.8.0
    # Semantic versioning will guarantee order for us here.
    if verlte "$VERSION" "4.8.0"; then
        URL="https://repo.continuum.io/miniconda/Miniconda3-${VERSION}-${OS_VERSION}.sh"
    else
        URL="https://repo.continuum.io/miniconda/Miniconda3-${PY_VERSION}_${VERSION}-${OS_VERSION}.sh"
    fi
    curl -L "$URL" > miniconda.sh
    bash miniconda.sh -b -f -p $CONDA_ROOT
    rm -f miniconda.sh
    touch $CONDA_ROOT/installed
else
    echo "Conda is already installed at $CONDA_ROOT."
fi
