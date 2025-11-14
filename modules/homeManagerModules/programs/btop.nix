# btop.nix
{
  pkgs,
  osConfig,
  ...
}: let
  btopPackage =
    if osConfig.myVars.isAMD
    then pkgs.btop-rocm
    else if osConfig.myVars.isNVIDIA
    then pkgs.btop-cuda
    else pkgs.btop; # else if osConfig.myVars.btop
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
