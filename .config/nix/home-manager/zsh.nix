{ config, ... }:
{
  programs.zsh = {
    enable = true;
    dotDir = config.home.homeDirectory;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      path = "$HOME/.local/state/zsh/history";
      size = 100000;
      save = 100000;
      extended = true;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
      expireDuplicatesFirst = true;
    };
    shellAliases = {
      awsp = "set-aws-profile";
      ll = "ls -la";
    };
    profileExtra = ''
      eval $(/opt/homebrew/bin/brew shellenv)
      export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
    '';
    initContent = ''
      fpath=("$HOME/.config/zsh/rc/functions/aws" "$HOME/.config/zsh/rc/functions/ghq" $fpath)
      autoload -Uz set-aws-profile ghq-fzf-cd
      source "$HOME/.config/zsh/rc/bindkey.zsh"
    '';
  };
}
