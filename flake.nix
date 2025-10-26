# flake.nix
# Author: danielgomezcoder@gmail.com
{
  description = "danielgomez3's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Options version as well
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager"; # hm-stable
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager"; # hm-unstable
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    # stylix.inputs.nixpkgs.follows = "nixpkgs";
    # DELTEME
    # stylix.inputs.home-manager.follows = "home-manager";
    mysecrets.url = "git+ssh://git@github.com/danielgomez3/nix-secrets.git?ref=main&shallow=1";
    mysecrets.flake = false;
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nix-netboot-serve.url = "github:determinatesystems/nix-netboot-serve";
    nur.url = "github:nix-community/NUR"; # Haven't used yet
    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
    quickemu.url = "https://flakehub.com/f/quickemu-project/quickemu/4.9.7";
    nix-on-droid.url = "github:nix-community/nix-on-droid/release-24.05";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    # MacOS emu
    nixtheplanet.url = "github:matthewcroughan/nixtheplanet";
    # nix-darwin
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs"; # Add this to your flake inputs
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    cosmic-manager.url = "github:HeitorAugustoLN/cosmic-manager";
    cosmic-manager.inputs.nixpkgs.follows = "nixpkgs";
    cosmic-manager.inputs.home-manager.follows = "home-manager";
    nvf.url = "github:notashelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = inputs @ {self, ...}: let
    supportedSystems = {
      linux = "x86_64-linux";
      darwinIntel = "x86_64-darwin";
      darwinAmd = "aarch64-darwin";
      android = "aarch64-linux";
    };
    pkgs = inputs.nixpkgs.legacyPackages.${supportedSystems.linux}; # FIXME Specify pkgs elsewhere if you can so we can have multi-profile setups
    pkgsUnstable = import inputs.nixpkgs-unstable {
      system = supportedSystems.linux;
    };
    commonImports = h: [
      # Every host dir may contain the following:
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
    myHelper = import ./lib/helpers/default.nix {
      inherit inputs;
      lib = inputs.nixpkgs.lib;
    };
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [pkgs.deploy-rs pkgs.pfetch]; # deps needed at runtime.
      GREETING = "Hello, Nix!";
      shellHook = ''
        ${pkgs.pfetch}/bin/pfetch
        echo $GREETING
      '';
    };

    nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
      modules = commonImports "laptop";
      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };

    nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
      modules = commonImports "desktop";
      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };

    nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
      modules = commonImports "server";
      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };

    nixosConfigurations.hetzner-vps = inputs.nixpkgs.lib.nixosSystem {
      modules = commonImports "hetzner-vps";
      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };

    # nix-on-droid switch --flake "github:danielgomez3/nix-config/deploy-rs#phone"
    nixOnDroidConfigurations.phone = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      modules = [./hosts/phone]; # HACK 'self' does NOT work
      pkgs = import inputs.nixpkgs {system = supportedSystems.android;};
      # specialArgs = {
      #   inherit inputs self pkgsUnstable myHelper;
      # };
    };

    darwinConfigurations.workLaptop = inputs.nix-darwin.lib.darwinSystem {
      modules = [
        "${self.outPath}/hosts/workLaptop"
        "${self.outPath}/modules/homeManagerModules"
        ./modules/nixosModules/features/my-vars.nix
        inputs.home-manager.darwinModules.home-manager
      ];
      specialArgs = {
        inherit inputs self myHelper pkgsUnstable;
      };
      #pkgs = import inputs.nixpkgs-unstable {
      #  system = "aarch64-darwin";
      #  config.allowBroken = true;
      #};
    };

    # deploy.nodes.example = {
    #     hostname = "example";
    #     sshUser = "root";  # Target machine's username
    #     fastConnection = true;  # Enable pipelined copying
    #     profiles.system = {
    #       user = "root";  # The user that the profile will be deployed to
    #       path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.example;
    #     };
    # };

    deploy.nodes.desktop = {
      hostname = "desktop";
      sshUser = "root"; # username of the target machine
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root"; # The user that the profile will be deployed to
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.desktop;
      };
    };

    deploy.nodes.laptop = {
      hostname = "laptop";
      sshUser = "root";
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.laptop;
      };
    };

    deploy.nodes.server = {
      hostname = "server";
      sshUser = "root";
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.server;
      };
    };

    deploy.nodes.hetzner-vps = {
      hostname = "danielgomezcoder.org";
      sshUser = "root";
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hetzner-vps;
      };
    };

    deploy.nodes.workLaptop = {
      hostname = "workLaptop";
      sshUser = "dgomez";
      # fastConnection = true;  # Enable pipelined copying
      remoteBuild = true;
      # autoRollback = false;
      # magicRollback = false;
      profiles.system = {
        # user = "admin";
        path = inputs.deploy-rs.lib.${supportedSystems.darwinAmd}.activate.darwin self.darwinConfigurations.workLaptop;
      };
    };
  };
}
