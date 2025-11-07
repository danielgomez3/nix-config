{
  lib,
  config,
  ...
}: let
  username = config.myVars.username;
in {
  myNixOS = {
    boot-to-steam-deck.enable = lib.mkDefault true;
  };

  # home-manager.users.${username}.myHomeManager = {
  # };
}
