{
  config,
  pkgs,
  lib,
  ...
}: {
  myNixOS = {
    cosmic.enable = true;
  };

  home-manager.users.${config.myVars.username}.myHomeManager = {
    my-cosmic-manager-settings.enable = true;
  };
}
