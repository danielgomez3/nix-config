# btop.nix
{
  pkgs,
  config,
  ...
}: let
  btopPackage =
    if config.myVars.isAMD
    then pkgs.btop-rocm
    else if config.myVars.isNVIDIA
    then pkgs.btop-cuda
    else pkgs.btop; # else if config.myVars.btop
in {
  programs.btop = {
    enable = true;
    package = btopPackage;
    settings = {
      show_gpu = true;
      gpu_support = true;
    };
  };
}
