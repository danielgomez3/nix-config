# desktop-gaming.nix
{
  lib,
  config,
  ...
}: {
  myNixOS = {
    minecraft-client.enable = true;
  };
  home-manager.users.${config.myVars.username}.myHomeManager = {
    mangohud.enable = true;
    steam.enable = true;
  };
}
