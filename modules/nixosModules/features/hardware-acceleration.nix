# hardware-acceleration.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    (lib.mkIf config.myVars.isINTEL {
      hardware.opengl.enable = true;
      hardware.opengl.extraPackages = with pkgs; [intel-media-driver];
      environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
      environment.systemPackages = [pkgs.nvtopPackages.intel];
    })

    (lib.mkIf config.myVars.isAMD {
      hardware.graphics.enable = true;
      environment.systemPackages = [pkgs.nvtopPackages.amd];
    })
  ];
}
