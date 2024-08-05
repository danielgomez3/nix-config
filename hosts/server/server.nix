
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ config, pkgs, lib, inputs, modulesPath, username, host, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../configurations/all.nix
      ../configurations/coding.nix
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      # /etc/nixos/hardware-configuration.nix
    ];

  # NOTE: Unique configuration.nix content for server:
  # environment.systemPackages = with pkgs; [
  #   libsForQt5.kdenlive
  # ];

  users.users.${username} = {
    description = "server";
  };
  hardware.keyboard.zsa.enable = true;

  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";  # Don't create default ~/Sync folder
  services = {
    coding = {
      enable = true;
      greeter = "Daniel";
    };
    plex = {
      enable = true;
      openFirewall = true;
    };
    syncthing = {
      guiAddress = "0.0.0.0:8384";
    };
  };



  # NOTE: Unique home-manager config for server:
  # home-manager = { 
  #   extraSpecialArgs = { inherit inputs; };
    # users.${username} = {
    #   programs = with pkgs; {
    #     kitty = {
    #       font = {
    #         size = 11;
    #       };
    #     };
    #   };
    # };
    # packages = with pkgs; [
    #   vim
    # ];

  # };

}
