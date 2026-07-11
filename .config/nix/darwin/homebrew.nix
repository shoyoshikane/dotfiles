{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "none";
      extraEnv = {
        HOMEBREW_NO_ENV_HINTS = "1";
        HOMEBREW_NO_UPDATE_REPORT_NEW = "1";
      };
    };

    brews = [
      "czg"
    ];

    casks = [
      "aws-vpn-client"
      "claude"
      "font-hackgen-nerd"
      "karabiner-elements"
      "keycastr"
      "middleclick"
      "notion"
      "raycast"
      "visual-studio-code"
      "wezterm@nightly"
    ];
  };
}
