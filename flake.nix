# flake.nix
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations = {

      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          username = "daniel";
          host = "desktop";
          };
        modules = [
          ./configurations/desktop.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          username = "daniel";
          host = "laptop";
        };
        modules = [
          ./configurations/laptop.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          username = "danielgomez3";
          host = "";
        };
        modules = [
          ./configurations/server.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      customIso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./scripts/installer/installer.nix
        ];
      };


    };
  };
}
