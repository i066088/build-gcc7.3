#!/bin/sh

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT


if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

export PATH=/usr/bin:$PATH
[[ ! -d ./build ]] && mkdir ./build
cd ./build


if [[ ! -f gmp-4.3.2.tar.bz2 ]]; then
        echo "downloading gmp-4.3.2.tar.bz2 ..."
        wget -q ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-4.3.2.tar.bz2
fi

if [[ ! -f mpfr-2.4.2.tar.bz2 ]]; then
        echo "downloading mpfr-2.4.2.tag.bz2 ..."
        wget -q ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-2.4.2.tar.bz2
fi

if [[ ! -f mpc-0.8.1.tar.gz ]]; then
        echo "downloading mpc-0.8.1.tar.gz ..."
        wget -q ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-0.8.1.tar.gz
fi

if [[ ! -f gcc-7.3.0.tar.gz ]]; then
        echo "downloading gcc-7.3.0.tar.gz ..."
        wget -q ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/gcc-7.3.0/gcc-7.3.0.tar.gz
fi

echo "extracting gmp-4.3.2.tar.bz2 ..."
if [[ -d gmp-4.3.2.tar.bz2 ]]; then
        rm -rf gmp-4.3.2/*
fi
tar xf gmp-4.3.2.tar.bz2

echo "extracting mpfr-2.4.2.tag.bz2 ..."
if [[ -d mpfr-2.4.2 ]]; then
        rm -rf mpfr-2.4.2/*
fi
tar xf mpfr-2.4.2.tar.bz2

echo "extracting mpc-0.8.1.tar.gz ..."
if [[ -d mpc-0.8.1.tar.gz ]]; then
        rm -rf mpc-0.8.1/*
fi
tar xzf mpc-0.8.1.tar.gz

echo "extracting gcc-7.3.0.tar.gz ..."
if [[ -d gcc-7.3.0 ]]; then
        rm -rf gcc-7.3.0/*
fi
tar xzf gcc-7.3.0.tar.gz

echo "building gmp-4.3.2 ..."
cd gmp-4.3.2
./configure
make
make install
#make check
cd ../
sudo ldconfig

echo "building mpfr-2.4.2 ..."
cd mpfr-2.4.2
./configure
make
make install
cd ../
sudo ldconfig

echo "building mpc-0.8.1 ..."
cd mpc-0.8.1
./configure
make
make install
cd ../
sudo ldconfig

echo "building gcc-7.3.0 ..."
cd gcc-7.3.0
./configure --disable-multilib
make -j8
make install
cd ..
sudo ldconfig

echo "Installation finished."
