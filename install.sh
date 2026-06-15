#!/bin/bash
# =============================================================================
# sig-beginners-pwn セットアップスクリプト (高速版)
#
# 最適化方針 (インストールされるツール構成は従来と完全に同一):
#   - `apt upgrade` を廃止 (最大の時間短縮)
#   - apt は「前提pkg + dockerリポジトリ追加」→「全pkgを1回でまとめてinstall」
#     に統合し、apt update / install の呼び出し回数を削減
#   - apt を使わない純粋なDL/ビルド処理は全てバックグラウンドで並列実行 (wait)
#   - apt を内部で使う pwndbg/gef のみ 1ジョブに直列化
#   - 並列実行でも ~/.bashrc を壊さないよう rustup は --no-modify-path
#   - 各並列ジョブのログは /tmp/install_<name>.log に分離
# =============================================================================
SH_PATH=$(cd "$(dirname "$0")" && pwd)
cd "$SH_PATH"

RAW="https://raw.githubusercontent.com/iwashiira/sig-beginners-pwn-public/main"

# 所要時間計測用: bash 組み込みの SECONDS を 0 にリセット (以降、経過秒を保持する)
SECONDS=0

# sudo の資格情報をキャッシュ (以降のバックグラウンドジョブがパスワード待ちで
# 固まらないように先頭で一度だけ確認する)
sudo -v || true

# -----------------------------------------------------------------------------
# 1. apt: 前提パッケージのインストール + docker リポジトリの追加
# -----------------------------------------------------------------------------
echo -e "\e[31m--- apt update / prerequisites ---\e[m"
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y ca-certificates curl wget

echo -e "\e[31m--- Docker repository setup ---\e[m"
# 競合する古いパッケージを除去 (未インストールでも無害)
sudo apt-get remove -y docker.io docker-doc docker-compose docker-compose-v2 \
    podman-docker containerd runc 2>/dev/null || true

# Docker 公式 GPG 鍵
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Apt sources にリポジトリを追加
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# -----------------------------------------------------------------------------
# 2. apt: 全パッケージをまとめて 1 回でインストール
#    (従来スクリプト中に分散していた全 apt install の和集合)
# -----------------------------------------------------------------------------
echo -e "\e[31m--- apt install (all packages) ---\e[m"
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y \
    docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    build-essential \
    ca-certificates \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    make \
    zip \
    unzip \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    libyaml-dev \
    python3 \
    python3-dev \
    python3-pip \
    gcc \
    gdb \
    tree \
    git \
    vim \
    pkg-config \
    netcat \
    patchelf \
    sudo \
    ruby \
    ruby-dev \
    qemu-system-x86 \
    musl-tools \
    gdb-multiarch \
    gdbserver \
    binutils \
    libc6-dbg \
    python3-venv \
    python3-setuptools \
    tzdata \
    file \
    colordiff \
    imagemagick
APT_SECONDS=$SECONDS
echo -e "\e[34m--- apt install successfully ended (${APT_SECONDS}s) ---\e[m"

# -----------------------------------------------------------------------------
# 3. 設定ファイルの配置
#    (nvm が ~/.bashrc に追記するため、.bashrc の取得は node ジョブより前に行う)
# -----------------------------------------------------------------------------
wget -q --tries=3 --timeout=30 "$RAW/.gdbinit" -O "$HOME/.gdbinit"
wget -q --tries=3 --timeout=30 "$RAW/.bashrc" -O "$HOME/.bashrc"
sudo wget -q --tries=3 --timeout=30 "$RAW/manage_aslr.sh" -O /usr/local/bin/aslr
sudo chmod +x /usr/local/bin/aslr

python3 -m pip install -U pip

# Tools ディレクトリを事前に作成 (pwndbg clone 先)
PWNDIR="$HOME/pwn"
TOOLS_DIR="$PWNDIR/Tools"
mkdir -p "$TOOLS_DIR"

# -----------------------------------------------------------------------------
# 4. 並列ジョブ定義
#    apt を内部で使わない処理は全て並列実行する
# -----------------------------------------------------------------------------

# ネットワーク耐性: 一過性のDLタイムアウト等で失敗した場合に最大3回までリトライする。
# (pwndbg/gef を並列実行すると uv の同時DLで回線が飽和し接続タイムアウトしやすいため)
retry() {
    local n=1 max=3
    until "$@"; do
        if [ "$n" -ge "$max" ]; then
            echo "[retry] '$*' が $max 回失敗しました" >&2
            return 1
        fi
        echo "[retry] '$*' 失敗 (試行 $n/$max)。15秒後に再試行" >&2
        n=$((n + 1))
        sleep 15
    done
}

# uv の HTTP タイムアウトを延長し、同時DL数を絞る (回線飽和時のタイムアウト対策)。
# pwndbg / gef の両タスクで使用する。
export UV_HTTP_TIMEOUT=300
export UV_CONCURRENT_DOWNLOADS=4

# neovim (prebuilt)
task_neovim() {
    wget -q --tries=3 --timeout=30 https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz -O /tmp/nvim-linux64.tar.gz
    tar xzf /tmp/nvim-linux64.tar.gz -C /tmp
    sudo cp /tmp/nvim-linux-x86_64/bin/nvim /usr/bin
    sudo cp -r /tmp/nvim-linux-x86_64/share/nvim /usr/share
    rm -f /tmp/nvim-linux64.tar.gz
    rm -rf /tmp/nvim-linux-x86_64
}

# checksec (latest release, prebuilt)
task_checksec() {
    sudo wget -q --tries=3 --timeout=30 "$(curl -s https://api.github.com/repos/slimm609/checksec/releases/latest \
        | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4)" -O /tmp/checksec.tar.gz
    mkdir -p /tmp/checksec
    tar xzf /tmp/checksec.tar.gz -C /tmp/checksec
    sudo cp /tmp/checksec/checksec /usr/local/bin/checksec
    sudo chmod +x /usr/local/bin/checksec
}

# rp++ (prebuilt)
task_rppp() {
    sudo wget -q --tries=3 --timeout=30 https://github.com/0vercl0k/rp/releases/download/v2.1.3/rp-lin-gcc.zip -O /tmp/rp++.zip
    unzip -o /tmp/rp++.zip -d /tmp
    sudo cp /tmp/rp-lin /usr/local/bin/rp++
    sudo chmod +x /usr/local/bin/rp++
}

# extract-vmlinux (kernel pwn 用)
task_extract_vmlinux() {
    sudo curl -fsSL https://raw.githubusercontent.com/torvalds/linux/master/scripts/extract-vmlinux \
        -o /usr/local/bin/extract-vmlinux
    sudo chmod +x /usr/local/bin/extract-vmlinux
}

# python パッケージ
task_pip() {
    retry python3 -m pip install pwntools pathlib2 ptrlib
}

# Rust ツールチェイン + ropr (ソースビルド)
# --no-modify-path: 並列実行する node ジョブと ~/.bashrc 書き込みが競合しないように。
# repo の .bashrc は末尾で $HOME/.cargo/env を source 済みなので PATH は通る。
task_rust() {
    retry bash -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path'
    . "$HOME/.cargo/env"
    retry cargo install ropr
}

# Node (nvm 経由)。nvm が ~/.bashrc に追記する。
task_node() {
    retry bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    retry nvm install 20
    node -v
    npm -v
}

# Ruby gems (apt は使わない: ruby/ruby-dev は上の apt で導入済み)
task_gems() {
    sudo gem install one_gadget seccomp-tools
}

# radare2 (公式プリビルド .deb をDLするのみ。ソースビルドは行わない)
# dpkg/apt ロックを避けるため、ここでは DL だけ行い、インストールは後処理(直列)で実施。
# バージョン取得は GitHub API ではなく releases/latest のリダイレクト先から行う
# (API はレート制限で空応答になりやすいため)。DL後に正当な .deb か検証してから残す。
_radare2_dl_once() {
    local ver url
    ver=$(curl -fsSL --retry 3 --max-time 30 -o /dev/null \
        -w '%{url_effective}' https://github.com/radareorg/radare2/releases/latest \
        | sed -E 's#.*/tag/##')
    if [ -z "$ver" ]; then
        echo "radare2: バージョン取得に失敗しました" >&2
        return 1
    fi
    url="https://github.com/radareorg/radare2/releases/download/${ver}/radare2_${ver}_amd64.deb"
    wget -q --tries=3 --timeout=30 "$url" -O /tmp/radare2.deb || return 1
    # DL したファイルが正当な .deb か検証 (空/HTML/途中切断を弾く)
    if ! dpkg-deb -I /tmp/radare2.deb >/dev/null 2>&1; then
        echo "radare2: ダウンロードした .deb が不正です (${url})" >&2
        rm -f /tmp/radare2.deb
        return 1
    fi
}

task_radare2_dl() {
    retry _radare2_dl_once
}

# gdb 拡張: pwndbg と gef。
# 本来この2つは setup スクリプト内部で apt-get を呼ぶため直列化が必要だったが、
# 解析の結果 apt 依存は固定パッケージ群のみと判明したので、それらを上の統合 apt
# install で前出ししたうえで、各スクリプト内の apt-get 呼び出しを `true` に置換して
# 無効化する。これにより両者から dpkg ロック獲得が消え、完全に並列実行できる。
# (重い処理である pwndbg の `uv sync` と gef の `uv pip install angr...` は apt では
#  なく venv ローカルの Python 依存解決であり、書き込み先も別なので衝突しない)

task_pwndbg() {
    # 再実行(再provision)冪等性: 既に clone 済みなら pull、無ければ clone。
    if [ -d "$TOOLS_DIR/pwndbg/.git" ]; then
        cd "$TOOLS_DIR/pwndbg" || return 1
        retry git pull --ff-only || true
    else
        retry git clone https://github.com/pwndbg/pwndbg "$TOOLS_DIR/pwndbg" || return 1
        cd "$TOOLS_DIR/pwndbg" || return 1
    fi
    # install_apt() 内の `sudo apt-get ...` を無効化 (依存は統合 apt install 済み)
    sed -i -E 's/sudo apt-get /true /g' setup.sh
    if grep -qE 'sudo apt-get ' setup.sh; then
        echo "[warn] pwndbg setup.sh: apt-get 呼び出しが残存しています" >&2
    fi
    # uv の DL が一過性タイムアウトしても全体を落とさないようリトライ。
    # setup.sh --update は冪等 (uv sync はDL再開、~/.gdbinit は更新モードで触らない)。
    retry env UV_HTTP_TIMEOUT="$UV_HTTP_TIMEOUT" UV_CONCURRENT_DOWNLOADS="$UV_CONCURRENT_DOWNLOADS" \
        DEBIAN_FRONTEND=noninteractive ./setup.sh --update
}

task_gef() {
    local s=/tmp/gef-install.sh
    wget -q --tries=3 --timeout=30 https://raw.githubusercontent.com/bata24/gef/dev/install-uv.sh -O "$s"
    # 冒頭の `apt-get ...` / `DEBIAN_FRONTEND=... apt-get ...` を無効化
    sed -i -E 's/^([[:space:]]*)(DEBIAN_FRONTEND=[^ ]+ )?apt-get /\1true /' "$s"
    if grep -qE '(^|[[:space:]])apt-get ' "$s"; then
        echo "[warn] gef install-uv.sh: apt-get 呼び出しが残存しています" >&2
    fi
    # gef は root 権限が必須 (id -u == 0 を要求)。uv の DL が一過性タイムアウトしても
    # 全体を落とさないようリトライ。install-uv.sh は冒頭で gef.py の存在を見て中断する
    # ため、(再実行/再試行の) 各回の前に gef.py を削除して冪等にする
    # (venv/DL済み分はそのまま再利用される)。
    sudo rm -f /root/.gef/gef.py
    local n=1 max=3
    until sudo env UV_HTTP_TIMEOUT="$UV_HTTP_TIMEOUT" UV_CONCURRENT_DOWNLOADS="$UV_CONCURRENT_DOWNLOADS" \
            DEBIAN_FRONTEND=noninteractive sh "$s"; do
        if [ "$n" -ge "$max" ]; then
            echo "[retry] gef install が $max 回失敗しました" >&2
            return 1
        fi
        echo "[retry] gef install 失敗 (試行 $n/$max)。gef.py を掃除し15秒後に再試行" >&2
        sudo rm -f /root/.gef/gef.py
        n=$((n + 1))
        sleep 15
    done
}

# -----------------------------------------------------------------------------
# 5. 並列実行
# -----------------------------------------------------------------------------
PARALLEL_START=$SECONDS
echo -e "\e[31m--- Parallel installation (neovim / checksec / rp++ / extract-vmlinux / pip / rust / node / gems / radare2 / pwndbg / gef) ---\e[m"

pids=()
names=()
# 各ジョブは自身の所要秒数を末尾に __DURATION__=<秒> として書き出す。
run_bg() {
    local name="$1"
    {
        local _t0=$SECONDS
        "$name"
        local _rc=$?
        echo "__DURATION__=$((SECONDS - _t0))"
        exit "$_rc"
    } > "/tmp/install_${name}.log" 2>&1 &
    pids+=("$!")
    names+=("$name")
}

run_bg task_neovim
run_bg task_checksec
run_bg task_rppp
run_bg task_extract_vmlinux
run_bg task_pip
run_bg task_rust
run_bg task_node
run_bg task_gems
run_bg task_radare2_dl
run_bg task_pwndbg
run_bg task_gef

job_dur() { grep -oE '__DURATION__=[0-9]+' "/tmp/install_$1.log" 2>/dev/null | tail -1 | cut -d= -f2; }

fail=0
for i in "${!pids[@]}"; do
    if wait "${pids[$i]}"; then
        echo -e "\e[34m[ok]\e[m ($(job_dur "${names[$i]}")s) ${names[$i]}"
    else
        echo -e "\e[31m[FAIL]\e[m ($(job_dur "${names[$i]}")s) ${names[$i]}  -> /tmp/install_${names[$i]}.log"
        echo "------ /tmp/install_${names[$i]}.log (tail -40) ------"
        tail -40 "/tmp/install_${names[$i]}.log" 2>/dev/null
        echo "------ end of ${names[$i]} log ------"
        fail=1
    fi
done
PARALLEL_SECONDS=$((SECONDS - PARALLEL_START))

# -----------------------------------------------------------------------------
# 6. 後処理 (並列ジョブの成果物に依存するため wait の後で実行)
# -----------------------------------------------------------------------------
sudo cp "$HOME/.gdbinit" /root
sudo mkdir -p /root/pwn
sudo ln -sfn "$TOOLS_DIR" /root/pwn/Tools

# radare2: DL 済みの .deb をインストール (依存解決は apt 任せ。apt lists 削除より前に実施)
# 正当な .deb の場合のみ install する (壊れたファイルを渡すと apt がメタデータ解析で落ちるため)
if dpkg-deb -I /tmp/radare2.deb >/dev/null 2>&1; then
    sudo DEBIAN_FRONTEND=noninteractive apt install -y /tmp/radare2.deb
    rm -f /tmp/radare2.deb
else
    echo -e "\e[31m[FAIL]\e[m radare2: 有効な .deb がありません (task_radare2_dl 失敗の可能性)"
    rm -f /tmp/radare2.deb
    fail=1
fi

# apt キャッシュの掃除
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*

# -----------------------------------------------------------------------------
# 所要時間サマリ
# -----------------------------------------------------------------------------
fmt() { printf '%dm%02ds' "$(($1 / 60))" "$(($1 % 60))"; }
echo -e "\e[36m===== 所要時間サマリ =====\e[m"
echo "  apt フェーズ      : $(fmt "$APT_SECONDS")  (${APT_SECONDS}s)"
echo "  並列フェーズ      : $(fmt "$PARALLEL_SECONDS")  (${PARALLEL_SECONDS}s)"
echo "  合計(install.sh)  : $(fmt "$SECONDS")  (${SECONDS}s)"
echo -e "\e[36m=========================\e[m"

if [ "$fail" -ne 0 ]; then
    echo -e "\e[31m--- Some tasks FAILED. Check /tmp/install_*.log ---\e[m"
    exit 1
fi
echo -e "\e[34m--- All installation successfully ended ---\e[m"
