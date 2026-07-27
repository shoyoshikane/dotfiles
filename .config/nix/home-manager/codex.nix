{
  config,
  lib,
  pkgs,
  ...
}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
in
{
  home.activation.codexHome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CODEX_HOME="$HOME/.codex"
    mkdir -p "$CODEX_HOME"

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
