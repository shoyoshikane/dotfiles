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
    run mkdir -p "$CODEX_HOME"

    if [ -L "$CODEX_HOME/skills" ] || [ -e "$CODEX_HOME/skills" ]; then
      run rm -rf "$CODEX_HOME/skills"
    fi
    run ln -s "${dotfilesPath}/.claude/skills" "$CODEX_HOME/skills"

    CODEX_CONFIG="$CODEX_HOME/config.toml"

    # config.toml の書き換えは一時ファイル経由の一連の処理なので、
    # run で個別にラップせず dry-run 時は全体をスキップする。
    if [ -n "''${DRY_RUN:-}" ]; then
      echo "Would update keymap settings in $CODEX_CONFIG"
    else
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
            print "submit = \"enter\""
            submit_written = 1
          }
        }

        function write_newline() {
          if (!newline_written) {
            print "insert_newline = \"shift-enter\""
            newline_written = 1
          }
        }

        function finish_section() {
          if (in_composer) {
            write_submit()
          }
          if (in_editor) {
            write_newline()
          }
          in_composer = 0
          in_editor = 0
        }

        /^\[/ {
          finish_section()
          if ($0 == "[tui.keymap.composer]") {
            in_composer = 1
            composer_found = 1
          } else if ($0 == "[tui.keymap.editor]") {
            in_editor = 1
            editor_found = 1
          }
          print
          next
        }

        in_composer && /^submit[[:space:]]*=/ {
          write_submit()
          next
        }

        in_editor && /^insert_newline[[:space:]]*=/ {
          write_newline()
          next
        }

        { print }

        END {
          finish_section()
          if (!composer_found) {
            print ""
            print "[tui.keymap.composer]"
            print "submit = \"enter\""
          }
          if (!editor_found) {
            print ""
            print "[tui.keymap.editor]"
            print "insert_newline = \"shift-enter\""
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
    fi
  '';
}
