#!/bin/bash
SH_PATH=$(cd $(dirname $0) && pwd)
cd $SH_PATH

echo -e "\e[31m--- NerdFonts uninstallation ---\e[m"

if [ -e $HOME/.config/fontconfig/conf.d/99-nerd-fonts.conf ]; then
  sudo rm $HOME/.config/fontconfig/conf.d/99-nerd-fonts.conf
fi


if [ -e $HOME/.local/share/fonts/NerdFonts ]; then
  sudo rm $HOME/.local/share/fonts/NerdFonts/UbuntuMonoNerd*.ttf
fi

cd $SH_PATH
fc-cache -fv
echo -e "\e[34m--- NerdFonts uninstallation successfully ended ---\e[m"
