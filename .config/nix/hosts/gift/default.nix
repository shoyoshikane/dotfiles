{ pkgs, ... }:
let
  username = "sho.yoshikane";
in
{
  networking.hostName = "gift";
  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true;

  # Keep this value stable after the first successful install.
  system.stateVersion = 5;

  environment.systemPackages = with pkgs; [
    git
    vim
  ];
}
