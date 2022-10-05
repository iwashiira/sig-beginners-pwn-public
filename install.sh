#!/bin/sh
SH_PATH=$(cd $(dirname $0) && pwd)
cd $SH_PATH

echo -e "\e[31m--- Pyenv installation ---\e[m"

sudo apt install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python-openssl \
    git

if [ -e $HOME/.pyenv ]; then
    sudo rm -r $HOME/.pyenv
fi

git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
pyenv install 3:latest
PY3_VER=$(pyenv whence 2to3 | grep 3.*)
pyenv global $PY3_VER

python3 -m pip install -U pip
echo -e "\e[34m--- Pyenv installation successfully ended ---\e[m"
