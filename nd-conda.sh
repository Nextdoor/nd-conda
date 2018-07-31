#!/bin/bash -e

if [[ $# == 1 ]]; then
    CONDA_ROOT=$1
else
    echo "Please specify the desired conda installation path as the only argument."
    exit 1
fi

VERSION="4.5.4"
LINUX_MD5="a946ea1d0c4a642ddf0c3a26a18bb16d"
MAC_MD5="164ec263c4070db642ce31bb45d68813"

# Get miniconda if it doesn't exist.
if [[ ! -f $CONDA_ROOT/installed ]]; then
    echo "Installing Conda to $CONDA_ROOT."
    if ! which sudo > /dev/null; then
        [[ ! -d $CONDA_ROOT ]] && mkdir $CONDA_ROOT
    else
        [[ ! -d $CONDA_ROOT ]] && sudo mkdir $CONDA_ROOT
        [[ -z $USER ]] && USER=root
        sudo chown $USER $CONDA_ROOT
    fi
    if [[ "$(uname)" == "Darwin" ]]; then
        URL="https://repo.continuum.io/miniconda/Miniconda3-$VERSION-MacOSX-x86_64.sh"
        curl "$URL" > miniconda.sh
        HASH=$(md5 -r miniconda.sh | cut -d" "  -f1)
        if [ "$HASH" != "$MAC_MD5" ]; then
            exit 1
        fi
    else
        URL="https://repo.continuum.io/miniconda/Miniconda3-$VERSION-Linux-x86_64.sh"
        curl "$URL" > miniconda.sh
        HASH=$(md5sum miniconda.sh | cut -d" "  -f1)
        if [ "$HASH" != "$MAC_MD5" ]; then
            exit 1
        fi
    fi
    bash miniconda.sh -b -f -p $CONDA_ROOT
    rm -f miniconda.sh
    touch $CONDA_ROOT/installed
else
    echo "Conda is already installed at $CONDA_ROOT."
fi
