# flake.nix
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # myPrivateFlakeRepo = {
    #   url = "github:danielgomez3/flake";
    #   # type = "github";
    #   # owner = "danielgomez3";
    #   # repo = "flake";
    # };
  };

  outputs = inputs@{ self, nixpkgs, ... }: 
    let 
      system = "x86_64-linux";
      username = "daniel";

      # Helper function to build stuff
      mkNixosSystem = args: nixpkgs.lib.nixosSystem {
        inherit (args) specialArgs modules;
      };
      commonSpecialArgs = { inherit inputs system username; };

    in {
      nixosConfigurations = {

        desktop = mkNixosSystem {
          specialArgs = commonSpecialArgs // {host = "desktop"; };
          modules = [
            ./hosts/desktop
            inputs.home-manager.nixosModules.default
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {
            host = "laptop";
          };
          modules = [
            ./devices/laptop/laptop.nix
            inputs.home-manager.nixosModules.default
          ];
        };

        server = nixpkgs.lib.nixosSystem {
          specialArgs = {
            username = "danielgomez3";
            host = "server";
          };
          modules = [
            ./devices/server/server.nix
            inputs.home-manager.nixosModules.default
          ];
        };

        rescueDevice = nixpkgs.lib.nixosSystem {
          specialArgs = {
            username = "rescue";
            host = "rescueDevice";
          };
          modules = [
            ./devices/rescueDevice/rescueDevice.nix
            inputs.home-manager.nixosModules.default
          ];
        };

        customIso = nixpkgs.lib.nixosSystem {
          modules = [
            ./scripts/installer/installer.nix
          ];
        };
      };
    };
}
