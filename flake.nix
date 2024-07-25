# flake.nix
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, ... }: 
    let 
      system = "x86_64-linux";
    in {
      nixosConfigurations = {

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
