# desktop-gaming.nix
{
  inputs,
  lib,
  config,
  ...
}: {
  myNixOS = {
    steam.enable = true;
    minecraft-client.enable = true;
  };
  home-manager.users.${config.myVars.username}.myHomeManager = {
    mangohud.enable = true;
  };
}
