#!/bin/bash
SH_PATH=$(cd $(dirname $0) && pwd)
cd $SH_PATH

sudo cp ./.bashrc $HOME

echo -e "\e[31m--- Pwnable Tools installation ---\e[m"

sudo apt update && sudo apt upgrade -y

echo -e "\e[31m--- Pyenv installation ---\e[m"

sudo apt install -y \
    build-essential \
    ca-certificates \
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
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    libyaml-dev \
    python3 \
    python3-pip \
    python-openssl \
    gcc \
    tree \
    git \
    libyaml-dev

if [ -e $HOME/.pyenv ]; then
    sudo rm -r $HOME/.pyenv
fi

git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
PYENV_ROOT="$HOME/.pyenv"
PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
pyenv install 3.11:latest
PY3_VER=$(pyenv whence 2to3 | grep 3.*)
pyenv global $PY3_VER

python3 -m pip install -U pip
echo -e "\e[34m--- Pyenv installation successfully ended ---\e[m"

echo -e "\e[31m--- Rbenv installation ---\e[m"

sudo apt install -y \
    build-essential \
    libssl-dev \
    zlib1g-dev

if [ -e $HOME/.rbenv ]; then
    sudo rm -r $HOME/.rbenv
fi

git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
RUBY_VER=$(rbenv install -l | grep -v - | tail -1)
rbenv install $RUBY_VER
rbenv global $RUBY_VER

echo -e "\e[34m--- Rbenv installation successfully ended ---\e[m"

sudo apt update && sudo apt install -y \
    build-essential \
    gdb \
    libssl-dev \
    libffi-dev \
    neovim \
    vim \
    curl \
    wget \
    pkg-config \
    git \
    netcat \
    patchelf \
    sudo \
    && sudo apt clean \
    && sudo rm -rf /var/lib/apt/lists/*

sudo wget https://github.com/downloads/0vercl0k/rp/rp-lin-x64 -O /usr/local/bin/rp++
sudo chmod +x /usr/local/bin/rp++

gem install one_gadget

python3 -m pip install pwntools pathlib2

PWNDIR="$HOME/pwn"
TOOLS_DIR="$PWNDIR/Tools"

if [ ! -e $PWNDIR ]; then
    mkdir $PWNDIR
fi
cd $PWNDIR

if [ ! -e $TOOLS_DIR ]; then
    mkdir $TOOLS_DIR
fi
cd $TOOLS_DIR

git clone https://github.com/longld/peda.git
git clone https://github.com/scwuaptx/Pwngdb.git
git clone https://github.com/radareorg/radare2
cd $TOOLS_DIR/radare2 && ./sys/install.sh

echo -e "\e[34m--- Pwnable Tools installation successfully ended ---\e[m"
