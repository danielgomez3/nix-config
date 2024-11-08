# modules/username.nix
{ config, pkgs, lib, ... }:

{
  options.myConfig.username = lib.mkOption {
    type = lib.types.str;
    default = "defaultUser"; # optional default
    description = "The username for this specific machine.";
  };

  config = {
    # Here, you can define any other configurations dependent on the `username`.
    # Example: Setting the default shell or home directory
  };
}

