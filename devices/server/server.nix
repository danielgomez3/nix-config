
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ config, pkgs, lib, inputs, modulesPath, username, host, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./configurations/all.nix
      ./configurations/coding.nix
      ./hardware-configuration.nix
      # /etc/nixos/hardware-configuration.nix
    ];

  # NOTE: Unique configuration.nix content for desktop:
  # environment.systemPackages = with pkgs; [
  #   libsForQt5.kdenlive
  # ];
  networking = {
    hostName = host;  # Define your hostname.
    dhcpcd.enable = false;
    interfaces.enp0s3.ipv4.addresses = [{
      address = "192.168.12.0";
      prefixLength = 24;  # Specifies subnet mask. Default value!
    }];
    defaultGateway = "192.168.1.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  users.users.${username} = {
    description = "server";
  };
  hardware.keyboard.zsa.enable = true;

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
    vim
    ];
  };

  # NOTE: Unique hardware-configuration.nix content for laptop:
}
