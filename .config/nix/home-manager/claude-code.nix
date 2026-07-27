{
  config,
  lib,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  # ~/.config/claude/ は activation script で管理する。
  # Claude 系の設定は小さく分かれているが、README 代わりの CLAUDE.md と
  # ルール・skills を home 側へ展開しておくと、各ツールから参照しやすい。
  home.activation.claudeFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CLAUDE_DIR="$HOME/.config/claude"

    if [ -L "$CLAUDE_DIR" ]; then
      rm "$CLAUDE_DIR"
    fi
    mkdir -p "$CLAUDE_DIR"

    for item in CLAUDE.md rules skills settings.local.json; do
      if [ -L "$CLAUDE_DIR/$item" ] || [ -e "$CLAUDE_DIR/$item" ]; then
        rm -rf "$CLAUDE_DIR/$item"
      fi
      case "$item" in
        CLAUDE.md)
          ln -s "${mkLink "CLAUDE.md"}" "$CLAUDE_DIR/$item"
          ;;
        settings.local.json)
          ln -s "${mkLink ".claude/settings.local.json"}" "$CLAUDE_DIR/$item"
          ;;
        *)
          ln -s "${mkLink ".claude/$item"}" "$CLAUDE_DIR/$item"
          ;;
      esac
    done
  '';

  home.activation.claudeHome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CLAUDE_HOME="$HOME/.claude"
    mkdir -p "$CLAUDE_HOME"

    if [ -L "$CLAUDE_HOME/skills" ] || [ -e "$CLAUDE_HOME/skills" ]; then
      rm -rf "$CLAUDE_HOME/skills"
    fi
    ln -s "${dotfilesPath}/.claude/skills" "$CLAUDE_HOME/skills"

    if [ -L "$CLAUDE_HOME/keybindings.json" ] || [ -e "$CLAUDE_HOME/keybindings.json" ]; then
      rm -f "$CLAUDE_HOME/keybindings.json"
    fi
    ln -s "${dotfilesPath}/.claude/keybindings.json" "$CLAUDE_HOME/keybindings.json"
  '';
}
