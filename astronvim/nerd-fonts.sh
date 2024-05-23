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
