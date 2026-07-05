{
  description = "Nix-managed macOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    {
      nixpkgs,
      darwin,
      home-manager,
      nix-homebrew,
      ...
    }:
    let
      system = "aarch64-darwin";
      hosts = {
        gift = ./hosts/gift;
      };
      mkDarwinConfiguration = host: hostModule:
        darwin.lib.darwinSystem {
          inherit system;

          modules = [
            ./modules/host-spec.nix
            hostModule
            ./darwin/homebrew.nix

            {
              nixpkgs.hostPlatform = system;
              nixpkgs.config.allowUnfree = true;
            }

            ({ config, pkgs, ... }:
              let
                username = config.hostSpec.username;
                hostName = config.hostSpec.hostName;
              in
              {
                assertions = [
                  {
                    assertion = host == hostName;
                    message = "hostSpec.hostName must match the darwinConfigurations attribute name.";
                  }
                ];

                networking.hostName = hostName;
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

                environment.systemPackages = with pkgs; [
                  git
                  vim
                ];

                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  backupFileExtension = "backup";
                  extraSpecialArgs = {
                    inherit username;
                  };
                  users.${username} = import ./home-manager;
                };

                nix-homebrew = {
                  enable = true;
                  enableRosetta = true;
                  user = username;
                  autoMigrate = true;
                  mutableTaps = true;
                };
              })

            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
          ];
        };
    in
    {
      darwinConfigurations = builtins.mapAttrs mkDarwinConfiguration hosts;
    };
}
