---
name: git-commit
description: Stage meaningful diffs and create WHY-focused commits for this dotfiles repo.
---

# git commit の作業指針

コミット可能な単位に変更を分けて、理由がわかるメッセージを書く。

## 見る範囲

- `git status --short --untracked-files`
- `git diff --stat`
- 必要な個別 diff

## 進め方

1. 変更を意味のある単位に分ける
2. 関連しない変更は混ぜない
3. 部分的に stage する必要があれば `git add -p` を使う
4. コミットメッセージは `type(scope): subject` を基本にする
5. body には diff の要約ではなく WHY を書く

## 判断基準

- 1 つの目的で説明できるか
- 動作変更と構造変更が混ざっていないか
- 先に検証すべき変更が残っていないか

## 注意

- バイパス前提のコミットはしない
- 変更理由が複数あるなら分ける
