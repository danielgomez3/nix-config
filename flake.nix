# flake.nix
# Author: danielgomezcoder@gmail.com
# # TODO when refactoring, make sure iso uses the right hardware files
# TODO: generate facter.nix for all machines, remove hardware-configuration
# TODO: refactor and remove boilerplate code.
# TODO: remove specialArgs?
# TODO: make shell that can be fetched from anywhere regardless of linux machine
{
  description = "danielgomezcoder's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Options version as well
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-kexec.url = "github:NixOS/nixpkgs/b81d4ded7076a39af7edfb1b50f024ef5fbb8b3f";
    home-manager.url = "github:nix-community/home-manager"; # hm-stable
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager"; # hm-unstable
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
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
    nixcraft.url = "github:loystonpais/nixcraft";
    nixcraft.inputs.nixpkgs.follows = "nixpkgs"; # Set correct nixpkgs name
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    jovian.inputs.nixpkgs.follows = "nixpkgs-unstable";
    alga.url = "github:Tenzer/alga"; # turn on TV's with WebOS
    nixos-generators.url = "github:nix-community/nixos-generators"; # create custom kexec tarballs, etc.
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs"; # create custom kexec tarballs, etc.
    nixos-images.url = "github:nix-community/nixos-images/"; # get a kexec tarball to use
    impermanence.url = "github:nix-community/impermanence"; # make custom iso data impermanent
    jambi.url = "github:guttermonk/jambi";
    # dictation.url = "github:jtara1/dictation";
    # dictation.inputs.nixpkgs.follows = "nixpkgs"; # where nixpkgs is your var for nixos nixpkgs in inputs
    nix-software-center.url = "github:snowfallorg/nix-software-center";
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
      "${self.outPath}/hosts/${h}/disk-config.nix"
      inputs.nixos-facter-modules.nixosModules.facter
      inputs.home-manager.nixosModules.default
      "${self.outPath}/modules/nixosModules"
      "${self.outPath}/modules/homeManagerModules"
      inputs.sops-nix.nixosModules.sops
      inputs.disko.nixosModules.disko
      inputs.stylix.nixosModules.stylix
    ];
    myHelper = import ./lib/helpers/default.nix {
      inherit inputs;
      lib = inputs.nixpkgs.lib;
    };
    # system = "x86_64-linux";
    nixpkgsNixosImages = inputs.nixos-images.inputs.nixos-unstable.legacyPackages."x86_64-linux";
  in {
    devShells.${supportedSystems.linux}.default = pkgs.mkShell {
      buildInputs = [pkgs.deploy-rs pkgs.pfetch]; # deps needed at runtime.
      GREETING = "Hello, Nix!";
      shellHook = ''
        ${pkgs.pfetch}/bin/pfetch
        echo $GREETING
      '';
    };
    packages.${supportedSystems.linux} = {
      custom-kexec =
        (nixpkgsNixosImages.nixos [
          inputs.nixos-images.nixosModules.kexec-installer
          inputs.nixos-images.nixosModules.noninteractive
          "${self.outPath}/lib/custom-iso/kexec/custom-kexec.nix" # FIXME renable? disabling this might be bad
          inputs.home-manager.nixosModules.default
          # "${self.outPath}/modules/homeManagerModules/"
          # "${self.outPath}/modules/nixosModules"
          "${self.outPath}/modules/nixosModules/features/my-vars.nix"
          # "${self.outPath}/modules/nixosModules/features/server-with-lid.nix"
          # "${self.outPath}/modules/nixosModules/features/core-system.nix"
        ]).config.system.build.kexecInstallerTarball;
      custom-iso = inputs.nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "iso";
        modules = commonImports "persistent-usb" ++ ["${self.outPath}/hosts/persistent-usb/hardware-configuration.nix"];
        specialArgs = {
          inherit inputs self pkgsUnstable myHelper;
        };
      };
    };

    # custom-iso = self.nixosConfigurations.myIso.config.system.build.isoImage;

    # nixosConfigurations.myIso = inputs.nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   modules = [
    #     # (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix")
    #     (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
    #     inputs.home-manager.nixosModules.default
    #     "${self.outPath}/modules/nixosModules"
    #     "${self.outPath}/modules/homeManagerModules"
    #     inputs.disko.nixosModules.disko
    #     "${self.outPath}/hosts/custom-iso"
    #     inputs.sops-nix.nixosModules.sops
    #     inputs.stylix.nixosModules.stylix # XXX: not sure why this needs to even be here
    #   ];
    #   specialArgs = {
    #     inherit inputs self pkgsUnstable myHelper;
    #   };
    # };

    # nixosConfigurations = {
    # exampleIso = inputs.nixpkgs.lib.nixosSystem {
    #   system = "x86_64-linux";
    #   modules = [
    #     ({
    #       pkgs,
    #       modulesPath,
    #       ...
    #     }: {
    #       imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
    #       environment.systemPackages = [pkgs.neovim];
    #     })
    #   ];
    #   specialArgs = {
    #     inherit inputs self pkgsUnstable myHelper;
    #   };
    # };
    # };

    nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
      system = supportedSystems.linux;
      modules =
        commonImports "laptop"
        ++ [
          {config.facter.reportPath = "${self.outPath}/hosts/laptop/facter.json";}
        ];

      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };

    nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
      modules = commonImports "desktop" ++ ["${self.outPath}/hosts/desktop/hardware-configuration.nix"];

      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };

    nixosConfigurations.server = inputs.nixpkgs.lib.nixosSystem {
      modules =
        commonImports "server"
        ++ [
          {config.facter.reportPath = "${self.outPath}/hosts/test-machine/facter.json";}
        ];

      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };

    nixosConfigurations.hetzner-vps = inputs.nixpkgs.lib.nixosSystem {
      modules = commonImports "hetzner-vps" ++ ["${self.outPath}/hosts/hetzner-vps/hardware-configuration.nix"];

      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };

    nixosConfigurations.living-room = inputs.nixpkgs.lib.nixosSystem {
      modules = commonImports "living-room" ++ ["${self.outPath}/hosts/living-room/hardware-configuration.nix"];
      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };

    nixosConfigurations.test-machine = inputs.nixpkgs.lib.nixosSystem {
      modules =
        commonImports "test-machine"
        ++ [
          {config.facter.reportPath = "${self.outPath}/hosts/test-machine/facter.json";}
        ];
      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };

    nixosConfigurations.llm-machine = inputs.nixpkgs.lib.nixosSystem {
      modules =
        commonImports "llm-machine"
        ++ [
          {config.facter.reportPath = "${self.outPath}/hosts/llm-machine/facter.json";}
        ];
      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };
    nixosConfigurations.nas-server = inputs.nixpkgs.lib.nixosSystem {
      modules =
        commonImports "nas-server"
        ++ [
          {config.facter.reportPath = "${self.outPath}/hosts/nas-server/facter.json";}
        ];
      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };
    nixosConfigurations.raw-image = inputs.nixpkgs.lib.nixosSystem {
      modules =
        commonImports "raw-image"
        ++ [
          {config.facter.reportPath = "${self.outPath}/hosts/raw-image/facter.json";}
        ];
      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };
    nixosConfigurations.persistent-usb = inputs.nixpkgs.lib.nixosSystem {
      modules = commonImports "persistent-usb" ++ ["${self.outPath}/hosts/persistent-usb/hardware-configuration.nix"];
      specialArgs = {
        inherit inputs self pkgsUnstable myHelper;
      };
    };

    # nix-on-droid switch --flake "github:danielgomez3/nix-config/deploy-rs#phone"
    # nixOnDroidConfigurations.phone = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
    #   modules = [./hosts/phone]; # HACK 'self' does NOT work
    #   pkgs = import inputs.nixpkgs {system = supportedSystems.android;};
    #   # specialArgs = {
    #   #   inherit inputs self pkgsUnstable myHelper;
    #   # };
    # };

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
      hostname = "192.168.1.159";
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
      hostname = "192.168.1.152";
      sshUser = "root";
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.server;
      };
    };

    deploy.nodes.hetzner-vps = {
      hostname = "5.161.110.156";
      sshUser = "root";
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hetzner-vps;
      };
    };

    deploy.nodes.living-room = {
      hostname = "living-room";
      sshUser = "root";
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.living-room;
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

    deploy.nodes.test-machine = {
      hostname = "test-machine";
      sshUser = "root"; # username of the target machine
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root"; # The user that the profile will be deployed to
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.test-machine;
      };
    };
    deploy.nodes.llm-machine = {
      hostname = "llm-machine";
      sshUser = "root"; # username of the target machine
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root"; # The user that the profile will be deployed to
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.llm-machine;
      };
    };
    deploy.nodes.nas-server = {
      hostname = "192.168.1.171";
      sshUser = "root"; # username of the target machine
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root"; # The user that the profile will be deployed to
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nas-server;
      };
    };
    deploy.nodes.raw-image = {
      hostname = "raw-image";
      sshUser = "root"; # username of the target machine
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root"; # The user that the profile will be deployed to
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.raw-image;
      };
    };
    deploy.nodes.persistent-usb = {
      hostname = "persistent-usb";
      sshUser = "root"; # username of the target machine
      fastConnection = true; # Enable pipelined copying
      profiles.system = {
        user = "root"; # The user that the profile will be deployed to
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.persistent-usb;
      };
    };
  };
}
