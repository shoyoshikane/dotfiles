{ lib, username, ... }:
{
  imports = [
    ./dotfiles.nix
    ./fzf.nix
    ./git.nix
    ./lazygit.nix
    ./packages.nix
    ./starship.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  home.username = username;
  home.homeDirectory = lib.mkForce "/Users/${username}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
