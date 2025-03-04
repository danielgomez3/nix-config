
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ config, pkgs, lib, inputs, host, name, ... }:

let 
  username = config.myVars.username;
in
{
  myVars.username = "USERNAME";  # Specific username for this machine
  myVars.hostname = "HOSTNAME";  # Specific hostname for this machine
  users.users.${username} = {
    description = "server";
  };

  myNixOS = {
    bundles.base-system.enable = true;
    syncthing.enable = lib.mkOverride 9999 false;
  };

  home-manager.users.${username}.myHomeManager = {
    cli-apps.enable = true;
  };      

}
