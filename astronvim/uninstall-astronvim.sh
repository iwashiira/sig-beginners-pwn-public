#!/bin/bash
SH_PATH=$(cd $(dirname $0) && pwd)
cd $SH_PATH

echo -e "\e[31m--- NerdFonts uninstallation ---\e[m"

if [ -e $HOME/.config/fontconfig/conf.d/99-nerd-fonts.conf ]; then
  sudo rm $HOME/.config/fontconfig/conf.d/99-nerd-fonts.conf
fi


if [ -e $HOME/.local/share/fonts/NerdFonts ]; then
  sudo rm $HOME/.local/share/fonts/NerdFonts/Hack*.ttf
fi

cd $SH_PATH
fc-cache -fv
echo -e "\e[34m--- NerdFonts uninstallation successfully ended ---\e[m"

echo -e "\e[31m--- AstroNvim uninstallation ---\e[m"

if [ -e $HOME/.config/nvim ]; then
  sudo rm -rf $HOME/.config/nvim 
fi
if [ -e $HOME/.local/share/nvim ]; then
  sudo rm -rf $HOME/.local/share/nvim
fi
if [ -e $HOME/.local/state/nvim ]; then
  sudo rm -rf $HOME/.local/state/nvim
fi
if [ -e $HOME/.cache/nvim ]; then
  sudo rm -rf $HOME/.cache/nvim 
fi
echo -e "\e[34m--- AstroNvim uinstallation successfully ended ---\e[m"
