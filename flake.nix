# flake.nix
{
  description = "danielgomez3's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";  # Nix Options version as well
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-netboot-serve.url = "github:determinatesystems/nix-netboot-serve";
    nur.url = "github:nix-community/NUR";
    mysecrets = {
      url = "git+ssh://git@github.com/danielgomez3/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
    quickemu.url = "https://flakehub.com/f/quickemu-project/quickemu/4.9.7";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, disko, colmena, stylix, wayland-pipewire-idle-inhibit, nix-doom-emacs-unstraightened, ... }: 
    let 
      system = "x86_64-linux";
      pkgsUnstable = import nixpkgs-unstable { inherit system; };
      hive = colmena.lib.makeHive self.outputs.colmena;
      myHelper = import ./lib/helpers/default.nix {
        inherit inputs;
        lib = inputs.nixpkgs.lib;
        };
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
          inherit inputs myHelper self pkgsUnstable;
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
          "${self.outPath}/modules/homeManagerModules"
        ];
      };
      # NOTE: add additional hosts/machines using this code block:

      # _ = {name, node, pkgs, ... }:{
      #   deployment = {
      #     tags = ["${name}" "all"];
      #     targetHost = "${name}";
      #   };
      #   imports = commonImports "${name}";
      # };

      # NOTE: Desired hosts/machines:
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
      thinkpadserver = {name, node, pkgs, ... }:{
        deployment = {
          tags = ["${name}" "all"];
          targetHost = "${name}";
        };
        imports = commonImports "${name}";
      };

    };

  hydraJobs = {
    deployment = hive.toplevel;
  };
    
  };
}
