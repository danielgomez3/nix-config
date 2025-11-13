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
  myVars.username = "danielgomez3"; # Specific username for this machine
  myVars.hostname = "llm-machine"; # Specific hostname for this machine
  networking.hostName = config.myVars.hostname;

  users.users.${config.myVars.username} = {
    description = "this a machine with gpus to run LLMs";
  };

  myNixOS = {
    core-system.enable = true;
  };
}
