# flake.nix
{
  description = "danielgomez3's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";  # Nix Options version as well
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.11";  # hm-stable
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";  # hm-unstable
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
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
    nur.url = "github:nix-community/NUR";  # Haven't used yet
    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
    quickemu.url = "https://flakehub.com/f/quickemu-project/quickemu/4.9.7";
    nix-on-droid.url = "github:nix-community/nix-on-droid/release-24.05";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";
    # MacOS emu
    nixtheplanet.url = "github:matthewcroughan/nixtheplanet";
    # nix-darwin
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";  # Add this to your flake inputs
  };

  outputs = inputs@{ self, ... }: 
    let 
      supportedSystems = {
        linux = "x86_64-linux";
        darwinIntel = "x86_64-darwin"; 
        darwinAmd = "aarch64-darwin"; 
        android = "aarch64-linux"; 
      };
      pkgs = inputs.nixpkgs.legacyPackages.${supportedSystems.linux};  # FIXME Specify pkgs elsewhere if you can so we can have multi-profile setups
      pkgsUnstable = import inputs.nixpkgs-unstable {
        system = supportedSystems.linux;
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
      myHelper = import ./lib/helpers/default.nix {
        inherit inputs;
        lib = inputs.nixpkgs.lib;
      };
    in {

      devShells.x86_64-linux.default = pkgs.mkShell { 
        buildInputs = [ pkgs.deploy-rs pkgs.pfetch ];  # deps needed at runtime.
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

      # nix-on-droid switch --flake "github:danielgomez3/nix-config/deploy-rs#phone"
      nixOnDroidConfigurations.phone = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        modules = [ "${self.outPath}"/hosts/phone ];
        pkgs = import inputs.nixpkgs { system = supportedSystems.android; };
        # specialArgs = {
        #   inherit inputs self pkgsUnstable myHelper;
        # };
      };

      darwinConfigurations.workLaptop = inputs.nix-darwin.lib.darwinSystem {
          modules = [
            "${self.outPath}/hosts/workLaptop"
            inputs.home-manager.darwinModules.home-manager
          ];
          specialArgs = {
            inherit inputs self;
          };
          pkgs = import inputs.nixpkgs-unstable {
            system = "x86_64-darwin";
        };
      };

      # deploy.nodes.example = {
      #     hostname = "example";
      #     sshUser = "root";  # Target machine's username
      #     fastConnection = true;  # Enable pipelined copying
      #     profiles.system = {  # TODO explain
      #       user = "root";  # The user that the profile will be deployed to
      #       path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.example;
      #     };
      # };

      deploy.nodes.desktop = {
          hostname = "desktop";
          sshUser = "root";  # username of the target machine
          fastConnection = true;  # Enable pipelined copying
          profiles.system = {  # TODO explain
            user = "root";  # The user that the profile will be deployed to
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.desktop;
          };
      };

      deploy.nodes.laptop = {
          hostname = "laptop";
          sshUser = "root";
          fastConnection = true;  # Enable pipelined copying
          profiles.system = {  # TODO explain
            user = "root";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.laptop;
          };
      };

      deploy.nodes.server = {
          hostname = "server";
          sshUser = "root";
          fastConnection = true;  # Enable pipelined copying
          profiles.system = {  # TODO explain
            user = "root";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.server;
          };
      };

      deploy.nodes.workLaptop = {
          hostname = "admins-imac-pro";
          sshUser = "admin";
          # fastConnection = true;  # Enable pipelined copying
          remoteBuild = true;  # 
          autoRollback = false;
          magicRollback = false;
          profiles.system = {  # TODO explain
            user = "admin";
            path = inputs.deploy-rs.lib.${supportedSystems.darwinIntel}.activate.darwin self.darwinConfigurations.workLaptop;

          };
      };
      
  };
}
