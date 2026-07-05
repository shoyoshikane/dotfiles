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

    taps = [
      "felixkratz/formulae"
      "hashicorp/tap"
      "nikitabobko/tap"
    ];

    brews = [
      "argocd"
      "awscli"
      "borders"
      "fzf"
      "hashicorp/tap/terraform"
      "helm"
      "kubernetes-cli"
      "neovim"
      "node"
      "tree"
      "zoxide"
    ];

    casks = [
      "aerospace"
      "aws-vpn-client"
      "claude"
      "claude-code"
      "codex"
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
