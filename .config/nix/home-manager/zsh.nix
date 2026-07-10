{
  programs.zsh = {
    enable = true;
    shellAliases = {
      awsp = "set-aws-profile";
      ll = "ls -la";
    };
    profileExtra = ''
      eval $(/opt/homebrew/bin/brew shellenv)
    '';
    initContent = ''
      fpath=("$HOME/.config/zsh/rc/functions/aws" $fpath)
      autoload -Uz set-aws-profile
    '';
  };
}
