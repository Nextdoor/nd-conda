#!/bin/bash -e


VERSION="4.3.31"

if [[ $# == 2 ]]; then
    CONDA_ROOT=$1
    VERSION=$2
elif [[ $# == 1 ]]; then
    CONDA_ROOT=$1
else
    echo "Please specify the desired conda installation path as the only argument."
    exit 1
fi

INSTALL_CONDA=yes
if [[ -f $CONDA_ROOT/installed ]]; then
    INSTALLED_VERSION=$($CONDA_ROOT/bin/conda --version | cut -d" " -f2)
    if [[ "$INSTALLED_VERSION" != "$VERSION" ]]; then
        echo "Conda $INSTALLED_VERSION is installed at $CONDA_ROOT but $VERSION was requested"
        echo "Removing existing conda at $CONDA_ROOT"
        if ! which sudo > /dev/null; then
            rm -rf $CONDA_ROOT
        else
            sudo rm -rf $CONDA_ROOT
        fi

        sudo rm -rf $CONDA_ROOT
    else
        echo "Conda $VERSION is already installed at $CONDA_ROOT"
        INSTALL_CONDA=""
    fi
fi

if [[ $INSTALL_CONDA ]]; then
    echo "Installing Conda version $VERSION to $CONDA_ROOT."
    if ! which sudo > /dev/null; then
        [[ ! -d $CONDA_ROOT ]] && mkdir $CONDA_ROOT
    else
        [[ ! -d $CONDA_ROOT ]] && sudo mkdir $CONDA_ROOT
        [[ -z $USER ]] && USER=root
        sudo chown $USER $CONDA_ROOT
    fi
    if [[ "$(uname)" == "Darwin" ]]; then
        URL="https://repo.continuum.io/miniconda/Miniconda3-$VERSION-MacOSX-x86_64.sh"
    else
        URL="https://repo.continuum.io/miniconda/Miniconda3-$VERSION-Linux-x86_64.sh"
    fi
    curl "$URL" > miniconda.sh
    bash miniconda.sh -b -f -p $CONDA_ROOT
    rm -f miniconda.sh
    touch $CONDA_ROOT/installed
fi
