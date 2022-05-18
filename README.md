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

	WSL: ubuntu18.04をインストールする
		https://docs.microsoft.com/ja-jp/windows/wsl/install

[ubuntu18.04]　併記のコマンドを実行するだけでよい。git cloneを実行するカレントディレクトリは自分で決めること。

	[例]
	.
	└── pwn
    	├── Programs
    	└── Tools
        		├── peda
        		├── Pwngdb
        		└── radare2


	gcc: コンパイラ
		sudo apt update && sudo apt upgrade -y
		sudo apt install build-essential

	gdb: デバッガ	
		sudo apt install gdb

	python2:
		sudo apt install python

	peda: gdbの拡張
		git clone https://github.com/longld/peda.git

	pwngdb: pedaの拡張
		git clone https://github.com/scwuaptx/Pwngdb.git
        ~/.gdbinitを編集する。

	pwntools: pwn用のpythonライブラリ
		sudo apt install python-pip libssl-dev libffi-dev
		python -m pip install pwntools pathlib2


[オプション]　　radare2に興味がなければインストールする必要はない。

	radare2: デバッガ
		git clone https://github.com/radareorg/radare2
		cd radare2 ; sys/install.sh

## 2. Vagrantを使った環境構築
M1 Macを使っている人はVagrantを使うことはできない。

[host]　Vagrant,Virtualboxをそれぞれインストールすること。

	Vagrant: generic/ubuntu1804を使う
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
	
	# dockerのコンテナを作る。pwn_ubuntu1804は好きな名前にしてよい。かなり時間がかかるが、その代わり別でaptして何かをインストールする必要はない。再ビルドもこれ。
		docker-compose -p pwn_ubuntu1804 build
	
	# 以降コンテナの操作 docker-compose.ymlの存在するディレクトリ上で行うこと
	# コンテナの実行
		docker-compose up -d
	# コンテナの停止
		docker-compose stop
	# コンテナ名の確認、実行状態の確認。
		docker-compose ps
	# コンテナ内に入る
		docker exec -it sig-beginners-pwn-public_pwn_ubuntu1804_1 /bin/bash
		# または
		docker-compose exec pwn_ubuntu1804 bash
	# コンテナから出る
		Ctrl-D
	
	# コンテナ内での操作は~/pwn/Programsディレクトリの上のものしか保存されない。ほかの場所に作ったファイルはコンテナそのものを削除してしまったときに一緒に消える。
	# エディタはvimとneovimが入っています。

## 4. Limaを使った環境構築
M1 Macを使っている人はこちらを利用すること。ただし、Limaの下で動いているqemu-system-x86_64にはstackのアラインメント関連のチェックがなく、movaps命令でSIGSEGVが発生することがないことに留意。

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
	
	# ubuntu18.04の仮想マシンを起動
		limactl start --tty=false bionic-amd64.yml
	# 仮想マシンの一覧
		limactl list
	# 仮想マシンの中にはいる
		limactl shell bionic-amd64
	# 仮想マシンから出る
		Ctrl-D
	# 仮想マシンを止める
		limactl stop bionic-amd64

[ubuntu18.04]　併記のコマンドを実行するだけでよい。git cloneを実行するカレントディレクトリは自分で決めること。

	[例]
	.
	└── pwn
    	├── Programs
    	└── Tools
        		├── peda
        		├── Pwngdb
        		└── radare2


	gcc: コンパイラ
		sudo apt update && sudo apt upgrade -y
		sudo apt install build-essential

	gdb: デバッガ	
		sudo apt install gdb

	python2:
		sudo apt install python

	peda: gdbの拡張
		git clone https://github.com/longld/peda.git

	pwngdb: pedaの拡張
		git clone https://github.com/scwuaptx/Pwngdb.git
        ~/.gdbinitを編集する。

	pwntools: pwn用のpythonライブラリ
		sudo apt install python-pip libssl-dev libffi-dev
		python -m pip install pwntools pathlib2

	

[その他]

	仮想環境内ではCLIでちょっとしたコードを書くなりコピペするなりしてファイルを作るので、最低限のvi系エディタの扱いは慣れておくこと。
	インサートモードから出入りするコマンドと変更を保存するorしないで閉じるコマンドさえ覚えていれば十分である。
	python3でもpwntoolsは動くが、stringとbyte列を足し算で足せないのがそこそこ面倒なのでpython2を僕は使っている。
