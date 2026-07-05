{ lib, ... }:
let
  username = "sho.yoshikane";
in
{
  imports = [
    ./dotfiles.nix
  ];

  home.username = username;
  home.homeDirectory = lib.mkForce "/Users/${username}";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
