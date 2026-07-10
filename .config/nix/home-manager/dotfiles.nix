{ config, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  mkLink = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
in
{
  home.file.".zprofile".source = mkLink ".zprofile";
  home.file.".zshrc".source = mkLink ".zshrc";
  home.file.".gitconfig".source = mkLink ".gitconfig";
  home.file."Library/Application Support/Code/User/settings.json".source =
    mkLink ".config/vscode/settings.json";

  xdg.configFile."borders/bordersrc".source = mkLink ".config/borders/bordersrc";
  xdg.configFile."git/ignore".source = mkLink ".config/git/ignore";
  xdg.configFile."karabiner/karabiner.json" = {
    source = mkLink ".config/karabiner/karabiner.json";
    force = true;
  };
  xdg.configFile."nvim".source = mkLink ".config/nvim";
  xdg.configFile."starship.toml".source = mkLink ".config/starship.toml";
  xdg.configFile."wezterm/wezterm.lua".source = mkLink ".config/wezterm/wezterm.lua";
  xdg.configFile."zsh/rc/functions/aws".source = mkLink ".config/zsh/rc/functions/aws";
}
