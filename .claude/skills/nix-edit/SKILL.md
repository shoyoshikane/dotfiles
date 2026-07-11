---
name: nix-edit
description: Nix-managed dotfiles changes with narrow file scope and validation.
---

# Nix 変更の作業指針

`.config/nix/**` を触る時に使う。

## 見る範囲

- エントリ: `.config/nix/flake.nix`
- host 固有: `.config/nix/hosts/*`
- ユーザー共通: `.config/nix/home-manager/*`
- macOS 側: `.config/nix/darwin/*`
- 共通型やオプション: `.config/nix/modules/*`

## 進め方

1. 変更対象の module を特定する
2. 依存する 1〜3 ファイルだけ読む
3. 変更は最小差分にする
4. 必要なら `nix flake check --no-build ./.config/nix` で確認する
5. バージョン依存の挙動や module の仕様が絡むなら、公式ドキュメントを確認する

## 判断基準

- host 固有か、共通化すべきか
- Nix で表現するのが適切か
- 生成物を直接編集していないか

## 変更後の確認

- 構文や評価が必要なら `nix flake check --no-build ./.config/nix` を使う
- host に反映するなら対象 host を確認してから `darwin-rebuild switch --flake ./.config/nix#<host>` を使う
- `flake.lock` は依存更新の意図がある時だけ触る
