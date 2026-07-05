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
      flakePath = "$HOME/dotfiles/.config/nix";
      hosts = {
        gift = ./hosts/gift;
      };
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      mkApp = name: description: text: {
        type = "app";
        program = "${
          pkgs.writeShellApplication {
            inherit name text;
          }
        }/bin/${name}";
        meta.description = description;
      };
      currentHostScript = ''
        host="$(scutil --get LocalHostName)"
        if [ -z "$host" ]; then
          echo "LocalHostName is not set." >&2
          exit 1
        fi
      '';
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
                  (writeShellApplication {
                    name = "darwin-switch";
                    text = ''
                      sudo darwin-rebuild switch --flake "${flakePath}#${hostName}"
                    '';
                  })
                  (writeShellApplication {
                    name = "darwin-build";
                    text = ''
                      darwin-rebuild build --flake "${flakePath}#${hostName}"
                    '';
                  })
                  (writeShellApplication {
                    name = "darwin-check";
                    text = ''
                      darwin-rebuild check --flake "${flakePath}#${hostName}"
                    '';
                  })
                  (writeShellApplication {
                    name = "darwin-update";
                    text = ''
                      nix flake update --flake "${flakePath}"
                      sudo darwin-rebuild switch --flake "${flakePath}#${hostName}"
                    '';
                  })
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
      apps.${system} = {
        switch = mkApp "darwin-switch" "Apply the current host nix-darwin configuration" ''
          ${currentHostScript}
          sudo darwin-rebuild switch --flake "${flakePath}#$host"
        '';

        build = mkApp "darwin-build" "Build the current host nix-darwin configuration" ''
          ${currentHostScript}
          darwin-rebuild build --flake "${flakePath}#$host"
        '';

        check = mkApp "darwin-check" "Check the current host nix-darwin configuration" ''
          ${currentHostScript}
          darwin-rebuild check --flake "${flakePath}#$host"
        '';

        update = mkApp "darwin-update" "Update flake inputs and apply the current host configuration" ''
          ${currentHostScript}
          nix flake update --flake "${flakePath}"
          sudo darwin-rebuild switch --flake "${flakePath}#$host"
        '';
      };

      darwinConfigurations = builtins.mapAttrs mkDarwinConfiguration hosts;
    };
}
