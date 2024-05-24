# AstroNvimをEditorとして使用する場合

# Nerd FontをInstallする

- Nerd FontをHostにインストール
  - HostのターミナルでのNerd Fontでの表示のため
  - [Nerd Font Repository](https://github.com/ryanoasis/nerd-fonts)から好きなFontをダウンロードし、インストール

- Nerd Fontをターミナルの外観として指定する
   - Windows
     - Windows TerminalのWSLの外観から
       - 設定 > プロファイルの`Ubuntu 22.04 LTS` > 外観 > フォントフェイス
   - Mac
     - [Iterm2](https://iterm2.com/)を使用する
       - MacのデフォルトのterminalだとNerd Fontがバグる
   - Linux
     - GUI環境
       - terminalのFontをNerd Fontに変更する
     - CUI環境
       - `nerd-fonts.sh`を使用する
 
# AstroNvimをInstall

- astronvim.shを実行

```bash
git clone https://github.com/iwashiira/sig-beginners-pwn-public.git
cd sig-beginners-pwn-public && ./astronvim.sh
```
- LspをInstallした後のnvimを開いた画面で止まってしまうので、Windowを閉じる
  - ```bash
    q            #masonの画面を閉じる
    :q!          #untitledのファイルを保存せずに終了
    ```
  - `astronvim.sh`の`nvim -c "Mason"`をコメントアウトすると、LogのWindowは開かない
    - https://github.com/iwashiira/sig-beginners-pwn-public/blob/main/astronvim/astronvim.sh#L32
- astronvim.shを実行すると、ホームディレクトリに`pyrightconfig.json`が作られます。
  - このディレクトリを含んだ子ディレクトリの中のpythonファイルは、wildcard importのwarningが無視されます。
    - `from ptrlib import *`がwarningを吐かなくなります。
    - 必要でなければ、削除して大丈夫です。
