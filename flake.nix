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

  outputs = inputs@{ self, nixpkgs, disko, ... }: {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      };
      defaults = { pkgs, ... }: 
      {
        # TODO
        deployment = {
          targetPort = 22;
        };
      };
      desktop = {
        deployment = {
          # TODO
          targetHost = "danielgomezcoder-d.duckdns.org";
          targetUser = "daniel";
        };
      };
      laptop = {
        deployment = {
          # TODO
          targetHost = "danielgomezcoder-l.duckdns.org";
          targetUser = "daniel";
        };
      };
      server = {
        deployment = {
          # TODO
          targetHost = "danielgomezcoder-s.duckdns.org";
          targetUser = "danielgomez3";
        };
      };
    };
  };
}
