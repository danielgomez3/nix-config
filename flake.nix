# flake.nix
{
  description = "danielgomez3's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # wezterm-flake.url = "github:wez/wezterm/main?dir=nix";
    # wezterm-flake.inputs.nixpkgs.follows = "nixpkgs";
    # hyprland.url = "github:hyprwm/Hyprland";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    colmena.url = "github:zhaofengli/colmena";
    stylix.url = "github:danth/stylix";
    mysecrets = {
      url = "git+ssh://git@github.com/danielgomez3/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  # outputs = inputs@{ self, nixpkgs, disko, colmena, stylix, ... }: 
  outputs = inputs@{ self, nixpkgs, disko, colmena, ... }: 
    let 
      system = "x86_64-linux";
      commonImports = h: [
        ./hosts/${h}
        ./hosts/${h}/hardware-configuration.nix
        ./hosts/${h}/disko-config.nix
      ];
    in  
    {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = system;
          config.permittedInsecurePackages = [  # FIXME: Remove this and figure out what depends!
            "dotnet-core-combined"
            "dotnet-sdk-6.0.428"
            "dotnet-sdk-wrapped-6.0.428"
            "dotnet-sdk-wrapped-6.0.428"
          ];
        };
        specialArgs = {
          inherit inputs;
        };
      };
      defaults = { pkgs, lib, ... }: 
      {
        # TODO
        deployment = {
          targetPort = 22;
          targetUser = "root";
        };
        imports = [
          inputs.home-manager.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          disko.nixosModules.disko
          inputs.stylix.nixosModules.stylix
          # {
          #   nix.settings = {
          #     substituters = ["https://hyprland.cachix.org"];
          #     trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
          #   };
          # }
          ./modules
        ];
      };
      laptop = {name, node, pkgs, ... }:{
        deployment = {
          # TODO
          tags = ["${name}" "all"];
          targetHost = "${name}";
        };
        imports = commonImports "${name}";
      };
      server = {name, node, pkgs, ... }:{
        deployment = {
          # TODO
          tags = ["${name}" "all"];
          targetHost = "${name}";
        };
        imports = commonImports "${name}";
      };
      desktop = {name, node, pkgs, ... }:{
        deployment = {
          # TODO
          tags = ["${name}" "all"];
          targetHost = "${name}";
        };
        imports = commonImports "${name}";
      };
    };
  };
}
