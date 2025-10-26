{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  modpack = pkgs.fetchPackwizModpack {
    url = "http://danielgomezcoder.org/html/pack.toml";
    packHash = "sha256-ATIc/ezSJ7HdBq3lT5kC1vB2PN3uYKQo7a2WGUVjbaY=";
  };
in {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];
  environment.systemPackages = [pkgs.packwiz];

  # NOTE: reach via:
  # sudo systemctl status minecraft-server-rlcraft.service
  services.minecraft-servers = {
    enable = true;
    eula = true; # You MUST agree to Mojang's EULA

    servers.dannys-modpack-mc-server = {
      enable = true;
      autoStart = true;
      openFirewall = true;

      package = pkgs.fabricServers.fabric-1_20_1.override {loaderVersion = "0.17.3";};

      serverProperties = {
        "server-port" = 25565;
        "max-players" = 20;
        "motd" = "Danny's Server!";
        "difficulty" = 3;
      };

      # Symlink mods and config from the modpack
      symlinks = let
      in {
        "mods" = "${modpack}/mods";
      };

      # Optional: Add operators/whitelist
      operators = {
        yourUsername = {
          uuid = "bd690296-8253-4d62-9fa8-41b255f55696"; # Get from https://mcuuid.net/
          level = 4;
          bypassesPlayerLimit = true;
        };
      };
    };
  };
}
