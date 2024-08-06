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
      commonModules = [
        inputs.home-manager.nixosModules.default
        ./modules
      ];

    in {
      nixosConfigurations = {

        desktop = mkNixosSystem {
          specialArgs = commonSpecialArgs // { host = "desktop"; };
          modules = commonModules ++ [ ./hosts/desktop ];
        };
        laptop = mkNixosSystem {
          specialArgs = commonSpecialArgs // { host = "laptop"; };
          modules = commonModules ++ [ ./hosts/laptop ];
        };
        server = mkNixosSystem {
          specialArgs = commonSpecialArgs // { username = "danielgomez3"; host = "server"; };
          modules = commonModules ++ [ ./hosts/server ];
        };
        rescueDevice = mkNixosSystem {
          specialArgs = commonSpecialArgs // { username = "rescue"; host = "laptop"; };
          modules = commonModules ++ [ ./hosts/rescueDevice ];
        };
        # FIXME not really used or working..
        customIso = mkNixosSystem {
          modules = [ ./hosts/customIso ];
        };
      };
    };
}
