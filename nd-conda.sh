#!/bin/bash -e

if [[ $# == 1 ]]; then
    CONDA_ROOT=$1
else
    echo "Please specify the desired conda installation path as the only argument."
    exit 1
fi

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
    # TODO(justyn): Flip back to using latest once 4.4.8 is released (contains a critical bug fix).
    if [[ "$(uname)" == "Darwin" ]]; then
        URL="https://repo.continuum.io/miniconda/Miniconda3-4.3.31-MacOSX-x86_64.sh"
    else
        URL="https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh"
    fi
    curl "$URL" > miniconda.sh
    bash miniconda.sh -b -f -p $CONDA_ROOT
    rm -f miniconda.sh
    touch $CONDA_ROOT/installed
else
    echo "Conda is already installed at $CONDA_ROOT."
fi
