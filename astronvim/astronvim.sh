#!/bin/bash
SH_PATH=$(cd $(dirname $0) && pwd)
cd $SH_PATH

echo -e "\e[31m--- NerdFonts installation ---\e[m"

if [ ! -e $HOME/.config/fontconfig/conf.d ]; then
  mkdir -p $HOME/.config/fontconfig/conf.d
fi

sudo cp ./nerd-fonts.conf $HOME/.config/fontconfig/conf.d/99-nerd-fonts.conf

if [ ! -e $HOME/.local/share/fonts/NerdFonts ]; then
  mkdir -p $HOME/.local/share/fonts/NerdFonts
fi

cd $HOME/.local/share/fonts/NerdFonts
curl -fLo "HackNerdFont-Bold.ttf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Hack/Bold/HackNerdFont-Bold.ttf
curl -fLo "HackNerdFont-BoldItalic.ttf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Hack/BoldItalic/HackNerdFont-BoldItalic.ttf
curl -fLo "HackNerdFont-Italic.ttf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Hack/Italic/HackNerdFont-Italic.ttf
curl -fLo "HackNerdFont-Regular.ttf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf

cd $SH_PATH
fc-cache -fv
echo -e "\e[34m--- NerdFonts installation successfully ended ---\e[m"

echo -e "\e[31m--- AstroNvim installation ---\e[m"

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
sudo rm -rf ~/.config/nvim/.git
nvim -c "q"
nvim -c "LspInstall rust_analyzer clangd jedi_language_server"
echo -e "\e[34m--- AstroNvim installation successfully ended ---\e[m"
