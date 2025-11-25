# llm-machine/default.nix
# NOTE: This contains all common features I want only my server to have!
{
  config,
  pkgs,
  lib,
  inputs,
  host,
  ...
}: {
  imports = [
  ];
  myVars.username = "daniel"; # Specific username for this machine
  myVars.hostname = "llm-machine"; # Specific hostname for this machine
  myVars.isNVIDIA = true;
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "this is machine with gpus for llms";
  };

  myNixOS = {
    bundles.pc-boot.enable = true;
    bundles.base-system.enable = true;
    nvidia-support.enable = true;
    # gnome.enable = true;
    rdp-server-gnome.enable = true;
  };
}
