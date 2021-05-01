#!/bin/bash

ONLY_MAIN_LIB=${1:-0}
INSTALL_PATH=${2:-"/usr/local/cpp-torch"}

export CMAKE_PREFIX_PATH=$INSTALL_PATH
export CMAKE_INSTALL_PREFIX=$INSTALL_PATH
export TORCH_INSTALL_DIR=$INSTALL_PATH

function install_libtorch() {

    libtorch_zipfile="libtorch-shared-with-deps-latest.zip"
    wget https://download.pytorch.org/libtorch/nightly/cpu/$libtorch_zipfile

    mkdir $INSTALL_PATH

    sudo unzip $libtorch_zipfile -d $INSTALL_PATH/

    rm $libtorch_zipfile
}

function redo_build_folder() {
    rm -rf $(pwd)/build/

    mkdir $(pwd)/build 

    cd build/
}

function install_th() {

    git clone https://github.com/tuotuoxp/torch7.git
    cd torch7
    mkdir build
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release ../lib/TH
    make
    sudo make install
    cd ../../
}


function install_thnn() {

    git clone https://github.com/tuotuoxp/nn.git
    cd nn
    mkdir build
    cd build
    cmake -DCMAKE_BUILD_TYPE=Release  ../lib/THNN
    make
    sudo make install
    cd ../../
}

function install_cpp_torch() {

    cd build/
    cmake -DCMAKE_BUILD_TYPE=Release  -DCMAKE_PREFIX_PATH=/usr/local/cpp-torch/libtorch/share/cmake/Torch/ -DTORCH_INSTALL_DIR=$INSTALL_PATH ..
    make
    sudo make install
}

function install_deps() {
    install_libtorch 
    redo_build_folder
    install_th
    install_thnn
}

function main() {

    if [[ $ONLY_MAIN_LIB -eq 0 ]]; then
        install_deps
        install_cpp_torch
    else
        install_cpp_torch
    fi

}

main
