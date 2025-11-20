{
  pkgs,
  inputs,
  config,
  ...
}: let
  # host = config.nixpkgs.hostPlatform;
in {
  environment.systemPackages = [inputs.jambi.packages.${config.nixpkgs.hostPlatform.system}.default];
}
