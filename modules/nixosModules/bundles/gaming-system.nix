{
  lib,
  config,
  ...
}: let
  username = config.myVars.username;
in {
  myNixOS = {
    steam.enable = lib.mkDefault true;
    boot-to-steam-deck.enable = lib.mkDefault true;
  };

  # home-manager.users.${username}.myHomeManager = {
  # };
}
