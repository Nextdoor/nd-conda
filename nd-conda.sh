#!/bin/bash -e

if [[ $# == 1 ]]; then
    CONDA_ROOT=$1
else
    CONDA_ROOT=/var/lib/conda
fi

# Get miniconda if it doesn't exist.
if [[ ! -f $CONDA_ROOT/installed ]]; then
    echo "Installing Conda to $CONDA_ROOT."
    if ! which sudo > /dev/null; then
        [[ ! -d $CONDA_ROOT ]] && mkdir $CONDA_ROOT
    else
        [[ ! -d $CONDA_ROOT ]] && sudo mkdir $CONDA_ROOT
        sudo chown $USER $CONDA_ROOT
    fi
    if [[ "$(uname)" == "Darwin" ]]; then
        URL="https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
    else
        URL="https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    fi
    curl "$URL" > miniconda.sh
    bash miniconda.sh -b -f -p $CONDA_ROOT
    rm -f miniconda.sh
    touch $CONDA_ROOT/installed
else
    echo "Conda is already installed at $CONDA_ROOT."
fi
