{
  pkgs,
  inputs,
  config,
  ...
}: {
  environment.systemPackages = [
    inputs.nix-software-center.packages.${config.nixpkgs.hostPlatform.system}.nix-software-center
  ];
}
