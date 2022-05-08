# sig-beginners-pwn

# 環境構築

[host]　Vagrant,Virtualbox, Ghidraをそれぞれインストールすること。Vagrantの代わりにWSL2を使ってもよい。

	Vagrant: generic/ubuntu1804を使う
		https://www.vagrantup.com/downloads
		自分の好みのディレクトリの下でvagrant initを実行する。
		ディレクトリ内に生成されたVagrantfileを、例に習って編集し保存する。
			割り当てるcpuの数、メモリ、名前は適宜自分の環境に合わせる。
		vagrant upを叩く(AntiVirusソフトが動いていると上手くいかないことがあるのでその時は一時的に止める。)
		vagrant upが終わったらvagrant sshで仮想環境内に入る。
		環境構築をする。
		Ctrl-Dで仮想環境から出て、vagrant haltで仮想環境を終了させる。
				
	Virtualbox:
		https://www.virtualbox.org/wiki/Downloads

	Ghidra: 最新のversionのものでよい。
		https://ghidra-sre.org/InstallationGuide.html#Install
		必ずjdk-11を使うこと

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


[オプション]　　radare2に興味がなければインストールする必要はありません。

	radare2: デバッガ
		git clone https://github.com/radareorg/radare2
		cd radare2 ; sys/install.sh


# Dockerを使った環境構築
M1 Macを使っている人はこの方法も利用できません。ptraceがサポートされておらず、gdbを使えないので。Windows用には作っていません。

[host] Dockerとdocker-composeをインストール

	Docker:
		https://docs.docker.com/get-docker/
	
	docker-compose:
		https://docs.docker.com/compose/install/

[docker] このリポジトリ内のDockerfileとdocker-compose.ymlを使います。環境が立ち上がるまでに時間がかかります。

	# Docker for Macを使っている場合は、Launchpadからappを起動してdockerとdocker-composeを使えるようにする。
	
	# 必要なDockerの設定ファイルを持ってくる。
		git clone https://github.com/iwashiira/sig-beginners-pwn-public.git
		cd sig-beginners-pwn-public
	
	# .envファイルを作成するほか、./Programsディレクトリのパーミッションをrwxにする。
		./set_dotenv.sh
		chmod 777 ./Programs
	
	# dockerのコンテナを作る。pwn_ubuntu1804は好きな名前にしてよい。かなり時間がかかります。その代わり別でaptして何かをインストールする必要はないです。再ビルドもこれ。
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
	
	# コンテナ内での操作は~/pwn/Programsディレクトリの上のものしか保存されません。ほかの場所に作ったファイルはコンテナそのものを削除してしまったときに一緒に消えます。
	# エディタはvimとneovimが入っています。

# Limaを使った環境構築
M1 Macを使っている人はこちらを利用してください。

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
		limactl start bionic-amd64.yml
	# 仮想マシンの一覧
		limactl list
	# 仮想マシンの中にはいる
		limactl shell bionic-amd64
	# 仮想マシンから出る
		Ctrl-D
	# 仮想マシンを止める
		limactl stop bionic-amd64
	

[その他]

	仮想環境内ではCLIでちょっとしたコードを書くなりコピペするなりしてファイルを
	作るので、最低限のvi系エディタの扱いは慣れておいてください。
	インサートモードから出入りするコマンドと変更を保存するorしないで閉じるコマンドさえ覚えていれば十分です。
	python3でもpwntoolsは動きますが、stringとbyte列を足し算で足せないのがそこそこ面倒なのでpython2を僕は使っています。
	M1 mac等のaarch64上でdockerを使ってamd64動かす場合、aslrが有効となっていてもlibcのアドレスなどがrandomize化されていないかもしれません。
