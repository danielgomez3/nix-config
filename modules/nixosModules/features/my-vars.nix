# modules/username.nix
{ config, pkgs, lib, ... }:

{
  options.myVars = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "error"; # optional default
      description = "The username for this specific machine.";
    };
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "error"; # optional default
      description = "The hostname for this specific machine.";
    };
    isHardwareLimited = lib.mkOption {
      type = lib.types.bool;
      default = false; # optional default
      description = "Is the machine hardware limited? Do we desire to save energy?";
    };
    isSyncthingServer = lib.mkOption {
      type = lib.types.bool;
      default = false; # optional default
      description = "Is the machine a Syncthing Server?";
    };
    isSyncthingClient = lib.mkOption {
      type = lib.types.bool;
      default = false; # optional default
      description = "Is the machine a Syncthing Client?";
    };
  };
}

