# desktop-gaming.nix
{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
    # inputs.nix-flatpak.homeManagerModules.nix-flatpak
    # inputs.flatpaks.homeManagerModules.nix-flatpak
  ];

  myNixOS = {
    steam.enable = true;
    minecraft-client.enable = true;
    roblox.enable = true;
  };
  home-manager.users.${config.myVars.username}.myHomeManager = {
    mangohud.enable = true;
  };
}
