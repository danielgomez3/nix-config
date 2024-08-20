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
      ssh-keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9OcZ6CO1lDXOMQQawee8Fh6iydI8I+SXMdD9GESq8v daniel@desktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHdnOQw9c23oUEIBdZFrKb/r4lHIKLZ9Dz11Un0erVsj danielgomez3@server"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGQ4W1AIoMxiKJQXOwJlkJkwZ0pMOe/akO86duVI/NWG daniel@laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYrgc8D5QnHXMZT+npgXshrn4LSfDy8qlwHF53m/dvz root@server"
      ];

      # Helper function to build nixosSystem
      # FIXME: commonSpecialArgs OR inheriting anyting in mkNixosSystem might not be necessary.
      mkNixosSystem = args: nixpkgs.lib.nixosSystem {
        inherit (args) specialArgs modules;
      };
      # NOTE: Default system and username here unless specified
      commonSpecialArgs = { inherit inputs system username ssh-keys; };  
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
        # deploy = mkNixosSystem {
        #   specialArgs = commonSpecialArgs // { username = "deploy"; host = "server"; };
        #   modules = ./hosts/server/hardware-configuration.nix ./hosts/deploy;
        # };
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
