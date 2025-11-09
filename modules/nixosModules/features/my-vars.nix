# my-vars.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
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
      description = "Is the machine hardware limited? Do we desire to save energy? Does scaling need to change?";
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

    # ports = {
    #   mc = 25565; # minecraft
    # };
    ports.mc = lib.mkOption {
      type = lib.types.port; # or lib.types.int
      default = 25565;
      description = "Minecraft server port";
    };
    isAMD = lib.mkOption {
      type = lib.types.bool;
      default = false; # optional default
      description = "Does the machine have an AMD GPU?";
    };
    isINTEL = lib.mkOption {
      type = lib.types.bool;
      default = false; # optional default
      description = "Does the machine have an INTEL GPU?";
    };
    isNVIDIA = lib.mkOption {
      type = lib.types.bool;
      default = false; # optional default
      description = "Does the machine have an NVIDIA GPU?";
    };
  };
}
