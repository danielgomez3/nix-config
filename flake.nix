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
      host = "laptop";
      commonImports = h: [
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        disko.nixosModules.disko
        ./hosts/${h}
        ./hosts/${h}/hardware-configuration.nix
        ./hosts/${h}/disko-config.nix
        ./modules
      ];
    in  
    {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = system;
        };
        specialArgs = {
          inherit inputs username host;
        };
      };
      defaults = { pkgs, lib, ... }: 
      {
        # TODO
        deployment = {
          targetPort = 22;
          targetUser = lib.mkDefault "daniel";
        };
      };
      testdevice = {
        deployment = {
          # TODO
          tags = ["testdevice" "all"];
          targetHost = "danielgomezcoder-d.duckdns.org";
        };
        imports = commonImports "testdevice";
        # boot.isContainer = true;
      };
    #   desktop = {
    #     deployment = {
    #       # TODO
    #       tags = ["desktop" "all"];
    #       targetHost = "danielgomezcoder-d.duckdns.org";
    #     };
    #     # imports = helperImports "desktop";
    #   };
    #   laptop = {
    #     deployment = {
    #       # TODO
    #       tags = ["laptop" "all"];
    #       targetHost = "danielgomezcoder-l.duckdns.org";
    #     };
    #     # imports = [
    #     #   ./hosts/laptop/configuration.nix
    #     # ];
    #   };
    #   server = {
    #     deployment = {
    #       # TODO
    #       tags = ["server" "all"];
    #       targetHost = "danielgomezcoder-s.duckdns.org";
    #       targetUser = "danielgomez3";
    #     };
    #     # imports = [
    #     #   ./hosts/server/configuration.nix
    #     # ];
    #   };
    };
  };
}
