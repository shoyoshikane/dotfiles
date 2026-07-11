---
name: nvim-edit
description: Neovim configuration changes with plugin-local file scope.
---

# Neovim 変更の作業指針

`.config/nvim/**` を触る時に使う。

## 見る範囲

- 入口: `.config/nvim/init.lua`
- 基本設定: `.config/nvim/lua/config/*`
- プラグイン: `.config/nvim/lua/plugins/*`

## 進め方

1. 変更対象の plugin か設定層を特定する
2. 関連する Lua ファイルだけ読む
3. 既存の LazyVim 流儀に合わせる
4. 可能なら設定は小さい単位に分ける

## 注意

- `lazy-lock.json` は更新が必要な時だけ触る
- 巨大な再編成より、既存構成への差し込みを優先する
