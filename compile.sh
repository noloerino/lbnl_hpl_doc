#!/bin/bash
# automates downloading/compiling of HPL linpack benchmark
# instructions courtesy of Matthew Li
# https://github.com/matthew-li/lbnl_hpl_doc

source ~/.bashrc
module load intel/2018.1.163
module load openmpi/2.0.2-intel
module load mkl/2018.1.163

VERSION="hpl-2.2"
download() {
    wget "http://www.netlib.org/benchmark/hpl/$VERSION.tar.gz"
    if [ $? -ne 0 ]; then
        echo "Download failed"
        exit 1
    fi

    tar -xvf "$VERSION.tar.gz"
}

#download

cd $VERSION

# helper function to replace a line in the makefile
set_field() {
    sed -i "/^$1\\b=*/c\\$1 = $2" $3
}

compile() {
    cp "setup/Make.Linux_Intel64" "Make.intel64"
    echo "editing makefile"
    FN="Make.intel64"
    set_field "ARCH" "\$(arch)" $FN
    set_field "TOPdir" $(pwd) $FN
    sed -i "s/libmkl_intel_thread.a/libmkl_sequential.a/g" $FN # not listed as a field
    set_field "CC" "mpicc" $FN
    set_field "OMP_DEFS" "-qopenmp" $FN

    echo "compiling"
    make -j20 arch=intel64
}

compile

if [ -e "bin/intel64/HPL.dat" ] && [ -e "bin/intel64/xhpl" ]; then
    echo "Please enter parameters in HPL.dat as specified here: https://github.com/matthew-li/lbnl_hpl_doc#3-gathering-parameters"
fi
