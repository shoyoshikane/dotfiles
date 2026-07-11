---
paths:
  - ".config/nvim/**"
---

# Neovim 変更ルール

- `init.lua` は入口としてだけ使い、実体は `lua/config/*` と `lua/plugins/*` に分ける
- plugin 単位の変更は、その plugin のファイルだけを先に読む
- `lazy-lock.json` は依存更新の意図がある時だけ触る
- 大きな再編成より、小さい差分を優先する
