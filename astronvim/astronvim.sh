#!/bin/bash
SH_PATH=$(cd $(dirname $0) && pwd)
cd $SH_PATH

echo -e "\e[31m--- AstroNvim installation ---\e[m"

cp ./pyrightconfig.json $HOME

if [ -e $HOME/.config/nvim ]; then
  sudo cp -r $HOME/.config/nvim $HOME/.config/nvim.bak
  sudo rm -rf $HOME/.config/nvim 
fi
if [ -e $HOME/.local/share/nvim ]; then
  sudo cp -r $HOME/.local/share/nvim $HOME/.local/share/nvim.bak
  sudo rm -rf $HOME/.local/share/nvim
fi
if [ -e $HOME/.local/state/nvim ]; then
  sudo cp -r $HOME/.local/state/nvim $HOME/.local/state/nvim.bak
  sudo rm -rf $HOME/.local/state/nvim
fi
if [ -e $HOME/.cache/nvim ]; then
  sudo cp -r $HOME/.cache/nvim $HOME/.cache/nvim.bak
  sudo rm -rf $HOME/.cache/nvim 
fi
git clone --depth 1 https://github.com/AstroNvim/template $HOME/.config/nvim
sudo rm -rf $HOME/.config/nvim/.git
nvim -c "q"

cd $SH_PATH
echo 'require "mason-config"' >>  $HOME/.config/nvim/init.lua
cp ./mason-config.lua $HOME/.config/nvim/lua/mason-config.lua
nvim -c "Mason"
echo -e "\e[34m--- AstroNvim installation successfully ended ---\e[m"
