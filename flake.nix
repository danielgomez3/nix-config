# flake.nix
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    deploy-flake = {
      url = "github:boinkor-net/deploy-flake";
      # The following are optional, but probably a good idea if you have these inputs:
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.rust-overlay.follows = "rust-overlay";
    };
  };

  outputs = inputs@{ self, nixpkgs, deploy-flake, ... }: 
    let 
      system = "x86_64-linux";
    in {
      nixosConfigurations = {

        apps.deploy-flake = deploy-flake.apps.deploy-flake.${system};

        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            username = "daniel";
            host = "desktop";
            };
          modules = [
            ./devices/desktop/desktop.nix
            inputs.home-manager.nixosModules.default
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            username = "daniel";
            host = "laptop";
          };
          modules = [
            ./devices/laptop/laptop.nix
            inputs.home-manager.nixosModules.default
          ];
        };

        server = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            username = "danielgomez3";
            host = "server";
          };
          modules = [
            ./devices/server/server.nix
            inputs.home-manager.nixosModules.default
          ];
        };

        customIso = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./scripts/installer/installer.nix
          ];
        };
      };
    };
}
