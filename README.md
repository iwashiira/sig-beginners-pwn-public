# sig-beginners-pwn
Hostの環境構築と、いずれかのGuestの環境構築を行うこと。

# Hostの環境構築

Ghidraをインストールすること。

	Ghidra: 最新のversionのものでよい。
		https://ghidra-sre.org/InstallationGuide.html#Install
		必ずjdk-11を使うこと

# Guestの環境構築
## 1. WSLを使った環境構築
Windowsを使っている人のみWSLを使うことができる。

[host]

	WSL: ubuntu22.04をインストールする
		https://docs.microsoft.com/ja-jp/windows/wsl/install

[ubuntu22.04]　下記のコマンドを実行するだけでよい。`~/pwn`ディレクトリができているはず。

	git clone https://github.com/iwashiira/sig-beginners-pwn-public.git
	cd ./sig-beginners-pwn-public
	./install.sh

[tree]	

	/root
 	├── .gdbinit
  	├── .gdbinit-gef.py
 	└── pwn
  		└── Tools -> /home/user/pwn/Tools
  
	/home/user
  	├── .bashrc
   	├── .gdbinit
	└── pwn
     	└──Programs
    	└── Tools
        		├── peda
        		├── Pwngdb
	  		├── pwndbg
        		└── radare2


## 2. Vagrantを使った環境構築
M1 Macを使っている人はVagrantを使うことはできない。

[host]　Vagrant,Virtualboxをそれぞれインストールすること。

	Vagrant: generic/ubuntu2204を使う
		https://www.vagrantup.com/downloads
		
	# 必要なVagrantfileを持ってくる。
		git clone https://github.com/iwashiira/sig-beginners-pwn-public.git
		cd sig-beginners-pwn-public
		Vagrantfileの割り当てるcpuの数、メモリ、名前は適宜自分の環境に合わせる。

	Virtualbox:
		https://www.virtualbox.org/wiki/Downloads

[vagrant] このリポジトリ内のVagrantfileを使う

	# VMを起動
		vagrant up
		# AntiVirusソフトが動いていると上手くいかないことがあるのでその時は一時的に止める。
		# 初回はprovisionが走る
	
	# VM内に入る。
		vagrant ssh
	# VMからでる
		Ctrl-D
	# VMを落とす
		vagrant halt
		# VMから出たあとに行う

## 3. Dockerを使った環境構築
M1 Macを使っている人はこの方法を利用できない。ptraceがサポートされておらず、gdbを使えないので。また、Dockerfile等はWindows用には作っていない。

[host] Dockerとdocker-composeをインストール

	Docker:
		https://docs.docker.com/get-docker/
	
	docker-compose:
		https://docs.docker.com/compose/install/

[docker] このリポジトリ内のDockerfileとdocker-compose.ymlを使います。環境が立ち上がるまでに時間がかかる。

	# Docker for Macを使っている場合は、Launchpadからappを起動してdockerとdocker-composeを使えるようにする。
	
	# 必要なDockerの設定ファイルを持ってくる。
		git clone https://github.com/iwashiira/sig-beginners-pwn-public.git
		cd sig-beginners-pwn-public
	
	# .envファイルを作成するほか、./Programsディレクトリのパーミッションをrwxにする。
		./set_dotenv.sh
		chmod 777 ./Programs
	
	# dockerのコンテナを作る。pwn_ubuntu2204は好きな名前にしてよい。かなり時間がかかるが、その代わり別でaptして何かをインストールする必要はない。再ビルドもこれ。
		docker-compose -p pwn_ubuntu2204 build
	
	# 以降コンテナの操作 docker-compose.ymlの存在するディレクトリ上で行うこと
	# コンテナの実行
		docker-compose up -d
	# コンテナの停止
		docker-compose stop
	# コンテナ名の確認、実行状態の確認。
		docker-compose ps
	# コンテナ内に入る
		docker exec -it sig-beginners-pwn-public_pwn_ubuntu2204_1 /bin/bash
		# または
		docker-compose exec pwn_ubuntu2204 bash
	# コンテナから出る
		Ctrl-D
	
	# コンテナ内での操作は~/pwn/Programsディレクトリの上のものしか保存されない。ほかの場所に作ったファイルはコンテナそのものを削除してしまったときに一緒に消える。
	# エディタはvimとneovimが入っています。

## 4. Limaを使った環境構築
M1 Macを使っている人はこちらを利用すること。~~ただし、Limaの下で動いているqemu-system-x86\_64にはstackのアラインメント関連のチェックがなく、movaps命令でSIGSEGVが発生することがないことに留意。~~ alignment違反で落ちるように修正されているかも。

[host] brewとLimaとgitをインストール

	brewのインストール
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	# .zshrcを作っていない人は作成
		touch ~/.zshrc
	# .zshrcにbrewのPathを通す
		# vimで~/.zshrcファイルを開く
			vim ~/.zshrc
		# iと打ってinsertモードに入り、以下の一行を追記
			export PATH=$PATH:/opt/homebrew
		# ESCでinsertモードから抜け、:wqと打って変更を保存
			source ~/.zshrc
		# brewが入っていることを確認
			brew help
	
	Limaとgitのインストール
		brew install lima git
	
	# 必要なLimaの設定を持ってくる
		git clone https://github.com/iwashiira/sig-beginners-pwn-public.git
		cd sig-beginners-pwn-public
		# 既にcloneしていた人は中身を更新
		cd sig-beginners-pwn-public
		git pull origin main

 	# cpuやmemoryなどを指定したい人は、jammy-amd64.ymlの中の対応するエントリをnullから変更する
	# ホストのディレクトリをマウントしたい人は、jammy-amd64.ymlの中のmounts部分のコメントアウトを外し、自身のProgramsの絶対pathを""内に書き込むこと。
	
	# ubuntu22.04の仮想マシンを作成して起動(初回, 時間がかかるのでtimeoutを伸ばす)
		limactl start --tty=false --timeout 60m0s jammy-amd64.yml
		# 別のターミナルから、以下のコマンドを打てば、進行状況などが分かる。
			tail -f -n 40 ~/.lima/jammy-amd64/serial.log
	# 仮想マシンの起動
		limactl start --tty=false jammy-amd64
	# 仮想マシンの一覧
		limactl list
	# 仮想マシンの中にはいる
		limactl shell jammy-amd64
	# 仮想マシンから出る
		Ctrl-D
	# 仮想マシンを止める
		limactl stop jammy-amd64
  
色々変更したい場合は[default.yml](https://github.com/lima-vm/lima/blob/master/examples/default.yaml)を参照のこと

## 全てのコマンドがinstallされているか確認する
	wget https://raw.githubusercontent.com/iwashiira/sig-beginners-pwn-public/main/command_chk.sh -O ./command_chk.sh
	chmod +x ./command_chk.sh && ./command_chk.sh

[ubuntu22.04]　

	# ホストのディレクトリをマウントしたい人は、以下のコマンドを打てば、ゲストのVM内の~/pwn/ProgramsとホストのProgramsディレクトリを繋ぐことができる。
		ln -s mount_path ~/pwn/Programs
		# mount_pathにはマウントした絶対Pathを入力

[gdbの拡張の使い方]

	# gdbを起動 (bata24/gefを使いたい場合はsudo必須)
 	sudo gdb --args file1 file2
  	# gdbを起動 (例えばchallというバイナリを動かしているプロセスにattach)
   	sudo gdb -p $(pidof chall)
	# 拡張を使う (起動後のgdbのシェルにコマンドを入力)
 	- gefを使う
  		(gdb) gef
  	- pwndbgを使う
   		(gdb) dbg
   	- pwngdbを使う
    	(gdb) pwngdb


[localでのサーバーの建て方]

	# dockerデーモンが起動しているか確認
		sudo service docker status
		# 起動していない場合は
			sudo service docker start
	# server/challディレクトリの中の各問題のディレクトリに移動し、docker-compose up -dとコマンドを打つ
	# lsof -iやdocker-compose ps、docker psなどのコマンドで空いているポートを確認
	# nc localhost {port_number} でサーバーに接続できます。

[その他]

	仮想環境内ではCLIでちょっとしたコードを書くなりコピペするなりしてファイルを作るので、最低限のvi系エディタの扱いは慣れておくこと。
	インサートモードから出入りするコマンドと変更を保存するorしないで閉じるコマンドさえ覚えていれば十分である。
