{
  pkgs,
  inputs,
  config,
  ...
}: {
  environment.systemPackages = [
    inputs.nix-software-center.packages.${config.nixpkgs.hostPlatform}.nix-software-center
  ];
}
