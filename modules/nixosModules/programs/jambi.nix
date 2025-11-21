{
  pkgs,
  inputs,
  config,
  ...
}: let
  # host = config.nixpkgs.hostPlatform;
in {
  environment.systemPackages = [
    inputs.jambi.packages.${pkgs.system}.default
  ];
}
