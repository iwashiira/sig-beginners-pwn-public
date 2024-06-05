#!/bin/bash
SH_PATH=$(cd $(dirname $0) && pwd)
cd $SH_PATH

if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1 ; then
  echo -e "\e[31m--- Node installation ---\e[m"

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  source $HOME/.bashrc

  nvm install 20
  echo -e "\e[34m--- Node installation successfully ended ---\e[m"
fi

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
sudo rm -rf $HOME/.config/nvim/.git
nvim -c "q"

nvim --headless -c "LspInstall lua_ls bashls clangd cmake cssls dockerls docker_compose_language_service html jsonls tsserver marksman pyright rust_analyzer yamlls" -c "qa"

echo -e "\n\e[34m--- AstroNvim installation successfully ended ---\e[m"
