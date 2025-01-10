# flake.nix
{
  description = "danielgomez3's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";  # Nix Options version as well
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix/release-24.11";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    colmena.url = "github:zhaofengli/colmena";
    # inputs.nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    mysecrets = {
      url = "git+ssh://git@github.com/danielgomez3/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, disko, colmena, stylix, ... }: 
  # outputs = inputs@{ self, nixpkgs, disko, colmena,  ... }: 
    let 
      system = "x86_64-linux";
      pkgsUnstable = import nixpkgs-unstable { inherit system; };
      myLib = import ./myLib/default.nix {inherit inputs;};
      commonImports = h: [  # Every host dir may contain the following:
        "${self.outPath}/hosts/${h}"
        "${self.outPath}/hosts/${h}/hardware-configuration.nix"
        "${self.outPath}/hosts/${h}/disko-config.nix"
      ];
    in 
    {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = system;
        };
        specialArgs = {
          inherit inputs myLib self pkgsUnstable;
        };
      };
      defaults = { pkgs, lib, ... }: 
      {
        deployment = {
          targetPort = 22;
          targetUser = "root";
        };
        imports = [
          inputs.home-manager.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          disko.nixosModules.disko
          inputs.stylix.nixosModules.stylix
          "${self.outPath}/modules/nixosModules"
        ];
      };
      # NOTE: add additional hosts/machines using this code block:
      # myDeviceAndHostname = {name, node, pkgs, ... }:{
      #   deployment = {
      #     tags = ["${name}" "all"];
      #     targetHost = "${name}";
      #   };
      #   imports = commonImports "${name}";
      # };

      # NOTE: Example hosts/machines:
      laptop = {name, node, pkgs, ... }:{
        deployment = {
          tags = ["${name}" "all"];
          targetHost = "${name}";
        };
        imports = commonImports "${name}";
      };
      server = {name, node, pkgs, ... }:{
        deployment = {
          tags = ["${name}" "all"];
          targetHost = "${name}";
        };
        imports = commonImports "${name}";
      };
      desktop = {name, node, pkgs, ... }:{
        deployment = {
          tags = ["${name}" "all"];
          targetHost = "${name}";
        };
        imports = commonImports "${name}";
      };
    };
  };
}
