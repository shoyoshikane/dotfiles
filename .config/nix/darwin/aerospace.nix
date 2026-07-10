{ ... }:
{
  services.aerospace = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../../aerospace/aerospace.toml);
  };
}
