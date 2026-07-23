{
  config,
  lib,
  pkgs,
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

  home.activation.claudeSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CLAUDE_HOME="$HOME/.claude"
    CODEX_HOME="$HOME/.codex"
    mkdir -p "$CLAUDE_HOME"
    mkdir -p "$CODEX_HOME"

    if [ -L "$CLAUDE_HOME/skills" ] || [ -e "$CLAUDE_HOME/skills" ]; then
      rm -rf "$CLAUDE_HOME/skills"
    fi
    ln -s "${dotfilesPath}/.claude/skills" "$CLAUDE_HOME/skills"

    if [ -L "$CLAUDE_HOME/keybindings.json" ] || [ -e "$CLAUDE_HOME/keybindings.json" ]; then
      rm -f "$CLAUDE_HOME/keybindings.json"
    fi
    ln -s "${dotfilesPath}/.claude/keybindings.json" "$CLAUDE_HOME/keybindings.json"

    if [ -L "$CODEX_HOME/skills" ] || [ -e "$CODEX_HOME/skills" ]; then
      rm -rf "$CODEX_HOME/skills"
    fi
    ln -s "${dotfilesPath}/.claude/skills" "$CODEX_HOME/skills"

    CODEX_CONFIG="$CODEX_HOME/config.toml"
    if [ -L "$CODEX_CONFIG" ] && [ ! -e "$CODEX_CONFIG" ]; then
      rm -f "$CODEX_CONFIG"
    fi
    if [ ! -e "$CODEX_CONFIG" ]; then
      touch "$CODEX_CONFIG"
      chmod 600 "$CODEX_CONFIG"
    fi

    CODEX_CONFIG_TMP="$(mktemp "$CODEX_HOME/config.toml.XXXXXX")"
    if ${pkgs.gawk}/bin/awk '
      function write_submit() {
        if (!submit_written) {
          print "submit = \"ctrl-enter\""
          submit_written = 1
        }
      }

      $0 == "[tui.keymap.composer]" {
        in_composer = 1
        composer_found = 1
        print
        next
      }

      in_composer && /^\[/ {
        write_submit()
        in_composer = 0
      }

      in_composer && /^submit[[:space:]]*=/ {
        write_submit()
        next
      }

      { print }

      END {
        if (in_composer) {
          write_submit()
        }
        if (!composer_found) {
          print ""
          print "[tui.keymap.composer]"
          print "submit = \"ctrl-enter\""
        }
      }
    ' "$CODEX_CONFIG" > "$CODEX_CONFIG_TMP"; then
      if cmp -s "$CODEX_CONFIG_TMP" "$CODEX_CONFIG"; then
        rm -f "$CODEX_CONFIG_TMP"
      else
        chmod 600 "$CODEX_CONFIG_TMP"
        mv "$CODEX_CONFIG_TMP" "$CODEX_CONFIG"
      fi
    else
      rm -f "$CODEX_CONFIG_TMP"
      exit 1
    fi
  '';
}
