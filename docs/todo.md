- Create an automated install process with nixos-anywhere and disko.
- Make sops nix hide ssh user alias in `all.nix`.


Here is my problem. I have a nix flake. I use colmena. The problem is that my 'username' is defined in the let binding early on, when I actually need it later in the configuration, because this forces my username across all systems to be the same, which offers no customization.
The problem is that all of my files, like all.nix, default.nix, and all other *.nix files under my 'modules' directory all rely on receiving a 'username' argument. But I can't provide that anymore, and it can't be inherited through 'colmena.meta.specialArgs'. So I'm not sure how to propogate a 'username' that's determined somewhere. I've heard I could create a custom nixos 'service' or module to propogate this, but this would somehow have to tie in to the machine-sepcific colmena machine. How would you go about this logically? 

Here is the structure of my nix flake repo:
nix-config on  colmena took 2m7s
✦ ❯ lt -L 3
 .
├──  docs
│  ├──  flake.md
│  ├──  index.md
│  ├──  install.md
│  └──  todo.md
├──  extra
│  ├──  nix-expressions
│  │  ├──  netboot
│  │  ├──  nixos-anywhere
│  │  ├──  colmena.nix
│  │  ├──  my-awesome-script.nix
│  │  └──  pxie-image.nix
│  ├──  pandoc-templates
│  │  └──  eisvogel
│  ├──  programs
│  │  ├──  cutefetch.nix
│  │  ├──  doom-emacs.nix
│  │  └──  nvchad.nix
│  ├──  scripts
│  │  ├──  internal
│  │  └──  personal
│  └──  shells
│     ├──  spleeter-shell.nix
│     └──  tailrec-shell.nix
├──  hosts
│  ├──  customIso
│  │  └──  default.nix
│  ├──  deploy
│  │  └──  default.nix
│  ├──  desktop
│  │  ├──  configuration.nix
│  │  ├──  custom_symbols
│  │  ├──  default.nix
│  │  ├──  disko-config.nix
│  │  ├──  hardware-configuration.nix
│  │  ├── 󰷖 key.pub
│  │  └── 󰷖 root-key.pub
│  ├──  laptop
│  │  ├──  default.nix
│  │  ├──  disko-config.nix
│  │  └──  hardware-configuration.nix
│  ├──  laptoptest
│  │  ├──  default.nix
│  │  └──  disko-config.nix
│  ├──  live-usb
│  │  └──  default.nix
│  ├──  server
│  │  ├──  default.nix
│  │  ├──  disko-config.nix
│  │  ├──  hardware-configuration.nix
│  │  └── 󰷖 key.pub
│  └──  testdevice
│     ├──  default.nix
│     ├──  disko-config.nix
│     └──  hardware-configuration.nix
├──  modules
│  ├──  additional
│  │  └──  suspend-and-hibernate.nix
│  ├──  all.nix
│  ├──  coding.nix
│  ├──  default.nix
│  ├──  gaming.nix
│  ├──  gui.nix
│  └──  virtualization.nix
├──  flake.lock
├──  flake.nix
├──  hive.nix
├──  justfile
├──  oldflake.nix
├──  README.md
└──  result -> /nix/store/f3wcgpvwxiwwl6y04s9sdgl8ziaqrl0g-nixos-system-server-24.05.20240925.759537f

nix-config on  colmena
✦ ❯

Here is my flake.nix
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
      # username = "daniel";
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
          # inherit inputs username;
          inherit inputs ;
        };
      };
      defaults = { pkgs, lib, ... }: 
      {
        # TODO
        deployment = {
          targetPort = 22;
          targetUser = "root";
        };
      };
      laptop = {name, node, pkgs, ... }:{
        deployment = {
          # TODO
          tags = ["${name}" "all"];
          targetHost = "192.168.12.135";
        };
        imports = commonImports "${name}";
      };
      desktop = {name, node, pkgs, ... }:{
        deployment = {
          # TODO
          tags = ["${name}" "all"];
          targetHost = "192.168.12.135";
        };
        imports = commonImports "${name}";
      };
    };
  };
}
