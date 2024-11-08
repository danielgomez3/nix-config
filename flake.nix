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
      system = "x86_64-linux";
      username = "daniel";
      # Helper function to build nixosSystem
      # FIXME: commonSpecialArgs OR inheriting anything in mkNixosSystem might not be necessary.
      # NOTE: Default system and username here unless specified
      # Helper function to get host-specific modules and their respective hardware-configuration.nix
    in  
    {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = system;
        };
      };
      defaults = { pkgs, lib, ... }: 
      {
        # TODO
        deployment = {
          targetPort = 22;
          targetUser = lib.mkDefault "daniel";
        };
        # import = [
          
        # ];
      };
      desktop = {
        deployment = {
          # TODO
          tags = ["desktop" "all"];
          targetHost = "danielgomezcoder-d.duckdns.org";
        };
        imports = [./hosts/desktop/hardware-configuration.nix];
      };
      laptop = {
        deployment = {
          # TODO
          tags = ["laptop" "all"];
          targetHost = "danielgomezcoder-l.duckdns.org";
        };
      };
      server = {
        deployment = {
          # TODO
          tags = ["desktop" "all"];
          targetHost = "danielgomezcoder-s.duckdns.org";
          targetUser = "danielgomez3";
        };
      };
    };
  };
}
