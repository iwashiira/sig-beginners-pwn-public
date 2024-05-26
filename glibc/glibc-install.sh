#!/bin/bash
SH_PATH=$(cd $(dirname $0) && pwd)
cd $SH_PATH
JOBS=$[$(grep processor /proc/cpuinfo | wc -l | sed 's/[^0-9]//g')]
echo -e "\e[31m--- Glibc installation ---\e[m"

sudo apt update && sudo apt install bear -y

PWNSRC=$HOME/Tools/srcpwn

INSTALL_FLAG=0

while read line
do
    Version=$line
    if [ $INSTALL_FLAG == 0 ] && [ ${Version:0:1} != '#' ]; then
        INSTALL_FLAG=1
    fi
done < ./glibc-list.txt

if [ $INSTALL_FLAG == 0 ]; then
    exit
fi

if [ -e /tmp/glibc ]; then
    sudo rm -r /tmp/glibc
fi
cd /tmp
git clone git://sourceware.org/git/glibc.git

mkdir -p $PWNSRC/glibc
cd $SH_PATH

while read line
do
    Version=$line
    if [ ${Version:0:1} != '#' ]; then
        GLIBC_VER=$PWNSRC/glibc/glibc-${Version}
        if [ ! -e $PWNSRC/glibc/glibc-${Version} ];then
            mkdir $PWNSRC/glibc/glibc-${Version}
            mkdir $GLIBC_VER/src
            mkdir $GLIBC_VER/build
            mkdir $GLIBC_VER/dest
            mkdir $GLIBC_VER/dest/usr
            mkdir $GLIBC_VER/dest/lib64
        fi
        if [ -e $PWNSRC/linux ]; then
            ln -s $PWNSRC/linux/include $GLIBC_VER/dest/usr/include
        fi
        cp /lib/x86_64-linux-gnu/libgcc* $GLIBC_VER/dest/lib64
        cd $GLIBC_VER/src
        cp -r /tmp/glibc .
        cd $GLIBC_VER/src/glibc
        git checkout release/${Version}/master
        cd $GLIBC_VER/build
        $GLIBC_VER/src/glibc/configure --prefix=$GLIBC_VER/dest
        bear make -j${JOBS} && make install -j${JOBS}
    fi
done < ./glibc-list.txt

sudo rm -r /tmp/glibc
echo -e "\e[34m--- Glibc installation successfully ended ---\e[m"
