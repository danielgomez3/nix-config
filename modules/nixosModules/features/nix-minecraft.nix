{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (inputs.nix-minecraft.lib) collectFilesAt;

  modpack = pkgs.fetchPackwizModpack {
    url = "http://danielgomezcoder.org/pack.toml";
    packHash = "sha256-sHw1MAGg+m0654LvATknwDkZHE4h1GrGK8ZNzhsXwVc="; # Replace with actual hash after first build
  };
in {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];

  services.minecraft-servers = {
    enable = false;
    eula = true;
    openFirewall = true;
    servers.fabric = {
      enable = true;

      # Use the versions from your modpack
      package = pkgs.fabricServers.fabric-1_20_1.override {
        loaderVersion = "0.17.3";
      };

      symlinks = collectFilesAt modpack "mods";
      # files = collectFilesAt modpack "config";
    };
  };
}
