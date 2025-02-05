# flake.nix
{
  description = "danielgomez3's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    mysecrets = {
      url = "git+ssh://git@github.com/danielgomez3/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, disko, ... }: 
    let 
      flakeRoot = ./.;
      system = "x86_64-linux";
      username = "daniel";
      # Helper function to build nixosSystem
      # FIXME: commonSpecialArgs OR inheriting anything in mkNixosSystem might not be necessary.
      mkNixosSystem = args: nixpkgs.lib.nixosSystem {
        inherit (args) specialArgs modules;
      };
      # NOTE: Default system and username here unless specified
      commonSpecialArgs = { inherit inputs system username flakeRoot; };  
      commonModules = [
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        disko.nixosModules.disko
        ./modules
      ];
      # Helper function to get host-specific modules and their respective hardware-configuration.nix
      hostModules = hostDir: commonModules ++ [
        "${hostDir}/hardware-configuration.nix"
        "${hostDir}/disko-config.nix"
        hostDir  # default.nix
      ];

    in {

      hydraJobs = {
        nixosConfigurations = {

          desktop = mkNixosSystem {
            specialArgs = commonSpecialArgs // { host = "desktop"; };
            modules = hostModules ./hosts/desktop;
          };
          # laptop = mkNixosSystem {
          #   specialArgs = commonSpecialArgs // { host = "laptop"; };
          #   modules = hostModules ./hosts/laptop;
          # };
          # laptoptest = mkNixosSystem {
          #   specialArgs = commonSpecialArgs // { host = "laptop"; };
          #   modules = hostModules ./hosts/laptoptest;
          # };
          # server = mkNixosSystem {
          #   specialArgs = commonSpecialArgs // { username = "danielgomez3"; host = "server"; };
          #   modules = hostModules ./hosts/server;
          # };
          # # NOTE: This needs to be encrypted AF. Maybe the whole usb needs to be encrypted as a result..
          # live-iso = mkNixosSystem {
          #   specialArgs = commonSpecialArgs // { host = "usb"; };
          #   modules = ./hosts/server/hardware-configuration.nix ./hosts/live-iso;
          # };
          # installer = mkNixosSystem {
          #   specialArgs = commonSpecialArgs // { username = "installer"; host = "usb"; };
          #   modules = ./hosts/server/hardware-configuration.nix ./hosts/installer;
          # };
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
    };
}
