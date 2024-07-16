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
          ./flakes/desktop.nix
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
          ./flakes/laptop.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      ## REVIEW: This is how you would add more!
      server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
      inherit inputs;
        username = "";
      };
        modules = [
          ./flakes/server.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
