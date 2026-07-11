{ pkgs, ... }:
{
  projectRootFile = ".git/config";

  programs = {
    actionlint.enable = true;
    nixfmt = {
      enable = true;
      package = pkgs.nixfmt;
    };
    shellcheck.enable = true;
    shfmt.enable = true;
    stylua.enable = true;
    taplo.enable = true;
    typos.enable = true;
    yamlfmt.enable = true;
  };

  settings.formatter = {
    nixfmt.includes = [ "**/*.nix" ];
    stylua.includes = [ "**/*.lua" ];
    shfmt.includes = [ "**/*.sh" ];
    shellcheck.includes = [ "**/*.sh" ];
    rumdl = {
      command = "${pkgs.rumdl}/bin/rumdl";
      options = [ "fmt" ];
      includes = [ "**/*.md" ];
    };
    taplo.includes = [ "**/*.toml" ];
    yamlfmt.includes = [
      "**/*.yaml"
      "**/*.yml"
    ];
  };
}
