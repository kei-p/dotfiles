# nix-darwin / home-manager セットアップ

Apple Silicon (aarch64-darwin) 向けの nix-darwin + home-manager 構成。

## 初回セットアップ手順

### 1. Nix のインストール

[Determinate Systems の installer](https://github.com/DeterminateSystems/nix-installer) など、`nix-command` / `flakes` を有効にしたインストーラを使うのが楽。
公式 installer を使う場合は、初回 switch 時に `--extra-experimental-features 'nix-command flakes'` を付ける。

### 2. 既存の `/etc` ファイルの退避

nix-darwin は `/etc/nix/nix.conf` / `/etc/bashrc` / `/etc/zshrc` を自身で管理する。
Nix インストーラがこれらに書き込んでいる場合、初回 switch で以下のエラーが出る：

```
error: Unexpected files in /etc, aborting activation
```

指示に従って `.before-nix-darwin` サフィックスを付けてリネームする：

```bash
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

switch 成功後、内容に問題がなければ削除して良い。

### 3. 初回 switch

このディレクトリで以下を実行：

```bash
sudo nix run nix-darwin -- switch --flake .#default
```

Nix の experimental features が有効化されていない場合はフラグを付ける：

```bash
sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#default
```

## 2回目以降の適用

`darwin-rebuild` がインストール済みなのでそちらを使う：

```bash
sudo darwin-rebuild switch --flake .#default
```

## 構成ファイル

- `flake.nix` — エントリポイント。`darwinConfigurations."default"` を出力
- `darwin.nix` — システムレベル設定（Homebrew、`system.defaults` など）
- `home.nix` — home-manager 経由のユーザー設定
- `my-packages/` — 自作パッケージ
- `bin/` — 補助スクリプト

## 補足

- `sudo` で実行すると `warning: $HOME ('/Users/kei-p') is not owned by you, falling back to ...` が出るが無害
- `nix run` を引数なしで実行すると `apps.<system>.default` などを探すため、このフレークでは失敗する。必ず `nix run nix-darwin -- switch --flake .#default` の形で呼ぶ
