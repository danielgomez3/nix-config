
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ config, pkgs, lib, inputs, modulesPath, username, host, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./configuration.nix
      # /etc/nixos/hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # NOTE: Unique configuration.nix content for desktop:
  # environment.systemPackages = with pkgs; [
  #   libsForQt5.kdenlive
  # ];
  users.users.${username} = {
    description = "server";
  };
  hardware.keyboard.zsa.enable = true;

  networking.hostName = host; # Define your hostname.
  services = {
    openssh = {
      hostKeys = [ 
        {
          bits = 4096;
          path = "/home/${username}/.ssh/ssh_host_rsa_key";
          type = "rsa";
        }
      ];
    };



  # NOTE: Unique home-manager config for desktop:
  home-manager = { 
    extraSpecialArgs = { inherit inputs; };
    # users.${username} = {
    #   programs = with pkgs; {
    #     kitty = {
    #       font = {
    #         size = 11;
    #       };
    #     };
    #   };
    # };
    home.packages = with pkgs; [
    vim git
    ];
  };

  # NOTE: Unique hardware-configuration.nix content for laptop:
}
