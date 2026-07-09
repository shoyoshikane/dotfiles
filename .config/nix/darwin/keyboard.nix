{ pkgs, ... }:
let
  disableSpotlightHotkeys = pkgs.writeShellScript "disable-spotlight-hotkeys" ''
    set -euo pipefail

    /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict>
      <key>enabled</key>
      <false/>
      <key>value</key>
      <dict>
        <key>parameters</key>
        <array>
          <integer>65535</integer>
          <integer>49</integer>
          <integer>1048576</integer>
        </array>
        <key>type</key>
        <string>standard</string>
      </dict>
    </dict>'

    /usr/bin/killall cfprefsd >/dev/null 2>&1 || true
  '';
in
{
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToControl = true;

  launchd.user.agents.disable-spotlight-hotkeys = {
    command = "${disableSpotlightHotkeys}";
    serviceConfig.RunAtLoad = true;
  };
}
