# flake.nix
{
  description = "danielgomez3's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";  # Nix Options version as well
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    stylix.url = "github:danth/stylix/release-24.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
    mysecrets.url = "git+ssh://git@github.com/danielgomez3/nix-secrets.git?ref=main&shallow=1";
    mysecrets.flake = false;
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nix-netboot-serve.url = "github:determinatesystems/nix-netboot-serve";
    nur.url = "github:nix-community/NUR";
    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
    quickemu.url = "https://flakehub.com/f/quickemu-project/quickemu/4.9.7";
    nix-on-droid.url = "github:nix-community/nix-on-droid/release-24.05";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, ... }: 
    let 
      system = "x86_64-linux";
      pkgsUnstable = import inputs.nixpkgs-unstable { inherit system; };
      myHelper = import ./lib/helpers/default.nix {
        inherit inputs;
        lib = inputs.nixpkgs.lib;
        };
      commonImports = h: [  # Every host dir may contain the following:
        "${self.outPath}/hosts/${h}"
        "${self.outPath}/hosts/${h}/hardware-configuration.nix"
        "${self.outPath}/hosts/${h}/disko-config.nix"
        inputs.home-manager.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
        inputs.stylix.nixosModules.stylix
        "${self.outPath}/modules/nixosModules"
        "${self.outPath}/modules/homeManagerModules"
      ];
    in 
    {
    nixosConfigurations = {
      laptop = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs; };
        system = system;
        modules = commonImports "laptop";
      };
    };
    nixOnDroidConfigurations.default = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = import inputs.nixpkgs { system = "aarch64-linux"; };
      modules = [ ./nix-on-droid.nix ];
    };

    # Deployments:
    deploy.nodes.laptop = {
      hostname = "laptop";
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.laptop;
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

  };
}
