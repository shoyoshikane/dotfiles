---
paths:
  - ".config/zsh/**"
  - ".config/starship.toml"
  - ".config/wezterm/**"
  - ".config/aerospace/**"
---

# Shell / terminal 変更ルール

- zsh は `rc/` に責務を分ける
- 再利用できる関数は `rc/functions/` に置く
- prompt や terminal 設定は単体ファイルとして扱い、余計な共通化はしない
- 動作確認が必要な場合だけ関連ファイルを読む
