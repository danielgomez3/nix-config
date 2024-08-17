# flake.nix
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # myPrivateFlakeRepo = {
    #   url = "github:danielgomez3/flake";
    # };
  };

  outputs = inputs@{ self, nixpkgs, ... }: 
    let 
      system = "x86_64-linux";
      username = "daniel";

      # Helper function to build nixosSystem
      # FIXME: commonSpecialArgs OR inheriting anyting in mkNixosSystem might not be necessary.
      mkNixosSystem = args: nixpkgs.lib.nixosSystem {
        inherit (args) specialArgs modules;
      };
      # NOTE: Default system and username here unless specified
      commonSpecialArgs = { inherit inputs system username; };  
      commonModules = [
        inputs.home-manager.nixosModules.default
        ./modules
      ];
      # Helper function to get host-specific modules and their respective hardware-configuration.nix
      hostModules = hostDir: commonModules ++ [
        "${hostDir}/hardware-configuration.nix"
        hostDir
      ];

    in {
      nixosConfigurations = {

        desktop = mkNixosSystem {
          specialArgs = commonSpecialArgs // { host = "desktop"; };
          modules = hostModules ./hosts/desktop;
        };
        laptop = mkNixosSystem {
          specialArgs = commonSpecialArgs // { host = "laptop"; };
          modules = hostModules ./hosts/laptop;
        };
        server = mkNixosSystem {
          specialArgs = commonSpecialArgs // { username = "danielgomez3"; host = "server"; };
          modules = hostModules ./hosts/server;
        };
        # rescueDevice = mkNixosSystem {
        #   specialArgs = commonSpecialArgs // { username = "rescue"; host = "laptop"; };
        #   modules = hostModules ./hosts/rescueDevice;
        # };
        # # FIXME not really used or working..
        # customIso = mkNixosSystem {
        #   modules = [ ./hosts/customIso ];
        # };
      };
    };
}
