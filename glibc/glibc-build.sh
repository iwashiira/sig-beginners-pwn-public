#!/bin/bash
SH_PATH=$(cd $(dirname $0) && pwd)
cd $SH_PATH
JOBS=$[$(grep processor /proc/cpuinfo | wc -l | sed 's/[^0-9]//g')]
echo -e "\e[31m--- Glibc installation ---\e[m"

sudo apt update && sudo apt install bear bison make -y

mkdir $SH_PATH/build
mkdir $SH_PATH/dest

SRC=$(find . -maxdepth 1 -type d -name 'glibc*' -exec basename {} \;)
cd $SRC
cd $SH_PATH/build
../$SRC/configure --prefix=$SH_PATH/dest
bear -- make -j${JOBS} && make install -j${JOBS}
echo -e "\e[34m--- Glibc installation successfully ended ---\e[m"
