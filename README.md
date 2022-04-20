# sig-beginners-pwn

# 環境構築

[host]　Vagrant,Virtualbox, Ghidraをそれぞれインストールすること。Vagrantの代わりにWSL2を使ってもよい。

	Vagrant: generic/ubuntu1804を使う
		https://www.vagrantup.com/downloads
		自分の好みのディレクトリの下でvagrant initを実行する。
		ディレクトリ内に生成されたVagrantfileを、別で渡す例に習って編集し保存する。
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

	radare2: デバッガ
		git clone https://github.com/radareorg/radare2
		cd radare2 ; sys/install.sh

	peda: gdbの拡張
		git clone https://github.com/longld/peda.git

	pwngdb: pedaの拡張
		git clone https://github.com/scwuaptx/Pwngdb.git
        ~/.gdbinitを編集する。

	pwntools: pwn用のpythonライブラリ
		sudo apt install python-pip libssl-dev libffi-dev
		python -m pip install pwntools pathlib2

[その他]

	仮想環境内ではCLIでちょっとしたコードを書くなりコピペするなりしてファイルを
	作るので、最低限のvi系エディタの扱いは慣れておいてください。
	インサートモードから出入りするコマンドと変更を保存するorしないで閉じるコマンドさえ覚えていれば十分です。
