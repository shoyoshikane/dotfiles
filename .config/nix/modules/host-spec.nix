{ lib, ... }:
{
  options.hostSpec = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "Primary macOS user for this host.";
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "nix-darwin configuration name and macOS host name.";
    };
  };
}
