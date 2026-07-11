---
paths:
  - ".config/nix/**/*.nix"
---

# Nix 変更ルール

- まず `flake.nix` か対象 host / module のどこを変えるか決める
- host 固有の差分は host に閉じる
- 共通化できる設定は `home-manager` や `modules` に寄せる
- `flake.lock` は依存更新の意図がある時だけ触る
- 変更後は必要に応じて `nix flake check --no-build ./.config/nix` を確認する
