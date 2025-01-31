
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ config, pkgs, lib, inputs, host, name, ... }:

let 
  username = config.myVars.username;
in
{
  myVars.username = "poopy";  # Specific username for this machine
  myVars.hostname = "stinky";  # Specific hostname for this machine
  users.users.${username} = {
    description = "server";
  };

  myNixOS = {
    bundles.base-system.enable = true;
  };

  home-manager.users.${username}.myHomeManager = {
    cli-apps.enable = true;
  };      

}
