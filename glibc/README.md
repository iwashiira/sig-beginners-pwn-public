# 環境内のglibcのソースコードリーディングとデバッグ

# glibcのソースコードを落とす

```bash
./glibc-source-install.sh
```

- `glibc-{version}`ディレクトリが出来る

# glibcのデバッグ

# glibcのソースコードリーディング

```bash
./glibc-build.sh
```

1. [glibcのソースコードを落とす](#glibcのソースコードを落とす)を実行
2. `build`ディレクトリでconfigureし、bear makeでbuildしながら`compile_commands.json`を生成(30分かかる)
3. `dest`ディレクトリにbuildしたlibcバイナリが生成される
4. `glibc-{version}`ディレクトリ内のソースコードをnvimで開くとindexingが始まる(30分かかる)
  - 誤って書き換えないように`-R`オプションの使用を推奨
  - ```bash
  nvim -R ./glibc-{version}/malloc/malloc.c
  ``` 
