---
name: shell-edit
description: zsh, starship, wezterm, aerospace, and small shell helper changes.
---

# shell / terminal 変更の作業指針

`.config/zsh/**`, `.config/starship.toml`, `.config/wezterm/**`, `.config/aerospace/**` を触る時に使う。

## 見る範囲

- zsh 本体: `.config/zsh/rc/*`
- prompt: `.config/starship.toml`
- terminal: `.config/wezterm/wezterm.lua`
- window manager: `.config/aerospace/aerospace.toml`

## 進め方

1. 影響範囲の狭いファイルだけ読む
2. 挙動の変化があるかを先に確認する
3. 小さく変更して、必要なら別ファイルに分割する

## 注意

- 使い回しできる関数は `rc/functions/` に寄せる
- 1 行の変更で済むなら、無理に構造化しすぎない
