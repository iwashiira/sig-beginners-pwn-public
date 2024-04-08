#!/bin/bash
SH_PATH=$(cd $(dirname $0) && pwd)
cd $SH_PATH

wget https://raw.githubusercontent.com/iwashiira/sig-beginners-pwn-public/main/.gdbinit -O $HOME/.gdbinit
sudo cp $HOME/.gdbinit /root
wget https://raw.githubusercontent.com/iwashiira/sig-beginners-pwn-public/main/.bashrc -O $HOME/.bashrc
sudo wget https://raw.githubusercontent.com/iwashiira/sig-beginners-pwn-public/main/manage_aslr.sh -O /usr/local/bin/aslr
sudo chmod +x /usr/local/bin/aslr

wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz /tmp/nvim-linux64.tar.gz
tar xzf /tmp/nvim-linux64.tar.gz /tmp/nvim-linux64/bin/nvim /tmp/nvim-linux64/share/nvim
sudo cp /tmp/nvim-linux64/bin/nvim /usr/bin
sudo cp -r /tmp/nvim-linux64/share/nvim /usr/share
rm /tmp/nvim-linux64.tar.gz
rm -r /tmp/nvim-linux64

echo -e "\e[31m--- Pwnable Tools installation ---\e[m"

sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

echo -e "\e[31m--- Pyenv installation ---\e[m"

sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt install -y \
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
    make \
    zip \
    unzip \
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
    python3-dev \
    python3-pip \
    gcc \
    tree \
    git \
    libyaml-dev \

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

echo -e "\e[31m--- Cargo installation ---\e[m"

curl https://sh.rustup.rs -sSf | sh -s -- -y

echo -e "\e[34m--- Cargo installation successfully ended ---\e[m"

sudo apt update && sudo apt install -y \
    build-essential \
    gdb \
    libssl-dev \
    libffi-dev \
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



sudo wget https://github.com/0vercl0k/rp/releases/download/v2.1.3/rp-lin-gcc.zip -O /tmp/rp++.zip
unzip /tmp/rp++.zip -d /tmp
sudo cp /tmp/rp-lin /usr/local/bin/rp++
sudo chmod +x /usr/local/bin/rp++

python3 -m pip install pwntools pathlib2 ptrlib

gem install one_gadget

cargo install ropr

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
git clone https://github.com/pwndbg/pwndbg
git clone https://github.com/radareorg/radare2
cd $TOOLS_DIR/pwndbg && DEBIAN_FRONTEND=noninteractive ./setup.sh --update
cd $TOOLS_DIR/radare2 && ./sys/install.sh

wget -q https://raw.githubusercontent.com/bata24/gef/dev/install.sh -O- | sudo DEBIAN_FRONTEND=noninteractive sh

sudo mkdir /root/pwn
sudo ln -s $TOOLS_DIR /root/pwn/Tools

echo -e "\e[34m--- Pwnable Tools installation successfully ended ---\e[m"
