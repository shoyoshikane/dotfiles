{ config, ... }:
{
  # Secrets can be added under `sops.secrets` after creating an age key and an
  # encrypted secrets file. Keeping the base module file-free lets a fresh host
  # evaluate before its key material has been provisioned.
  sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  xdg.enable = true;
}
