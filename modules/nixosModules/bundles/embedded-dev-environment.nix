{
  config,
  pkgs,
  lib,
  ...
}: let
  username = config.myVars.username;
in {
  environment.systemPackages = [pkgs.platformio-core pkgs.openocd];
}
