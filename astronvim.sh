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
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
sudo rm -rf ~/.config/nvim/.git
nvim -c "q"
nvim -c "LspInstall rust_analyzer clangd jedi_language_server"
