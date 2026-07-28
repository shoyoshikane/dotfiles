{
  config,
  lib,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
in
{
  # ~/.config/claude/ は activation script で管理する。
  # Claude 系の設定は小さく分かれているが、README 代わりの CLAUDE.md と
  # ルール・skills を home 側へ展開しておくと、各ツールから参照しやすい。
  home.activation.claudeFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CLAUDE_DIR="$HOME/.config/claude"

    if [ -L "$CLAUDE_DIR" ]; then
      run rm "$CLAUDE_DIR"
    fi
    run mkdir -p "$CLAUDE_DIR"

    for item in CLAUDE.md rules skills settings.local.json; do
      if [ "$item" = "CLAUDE.md" ]; then
        target="${dotfilesPath}/CLAUDE.md"
      else
        target="${dotfilesPath}/.claude/$item"
      fi
      if [ -L "$CLAUDE_DIR/$item" ] || [ -e "$CLAUDE_DIR/$item" ]; then
        run rm -rf "$CLAUDE_DIR/$item"
      fi
      run ln -s "$target" "$CLAUDE_DIR/$item"
    done
  '';

  home.activation.claudeHome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CLAUDE_HOME="$HOME/.claude"
    run mkdir -p "$CLAUDE_HOME"

    if [ -L "$CLAUDE_HOME/skills" ] || [ -e "$CLAUDE_HOME/skills" ]; then
      run rm -rf "$CLAUDE_HOME/skills"
    fi
    run ln -s "${dotfilesPath}/.claude/skills" "$CLAUDE_HOME/skills"

    if [ -L "$CLAUDE_HOME/keybindings.json" ] || [ -e "$CLAUDE_HOME/keybindings.json" ]; then
      run rm -f "$CLAUDE_HOME/keybindings.json"
    fi
    run ln -s "${dotfilesPath}/.claude/keybindings.json" "$CLAUDE_HOME/keybindings.json"
  '';
}
