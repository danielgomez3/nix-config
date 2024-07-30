
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
    plex = {
      enable = true;
      openFirewall = true;
    };
    syncthing = {
    #   enable = true;
    #   user = username;
    #   dataDir = "/home/${username}/.config/data";
    #   configDir = "/home/${username}/.config/syncthing";  # Folder for Syncthing's settings and keys
    #   overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    #   overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      guiAddress = "0.0.0.0:8384";
    #   settings = {
    #     options.urAccepted = -1;
    #   };
    #   settings = {
    #     folders = {
    #       "Documents" = {         # Name of folder in Syncthing, also the folder ID
    #         path = "/home/${username}/Documents";    # Which folder to add to Syncthing
    #         devices = [ "desktop" "server" ];      # Which devices to share the folder with
    #         autoAccept = true;
    #         id = "Documents";
    #       };
    #       "Projects" = {
    #         path = "/home/${username}/Projects";
    #         devices = [ "desktop" "server" ];
    #         autoAccept = true;
    #         id = "Projects";
    #       };
    #       "flake" = {
    #         path = "/home/${username}/flake";
    #         devices = [ "desktop" "server" ];
    #         autoAccept = true;
    #         id = "flake";
    #       };
    #       "Productivity" = {
    #         path = "/home/${username}/Productivity";
    #         devices = [ "desktop" "server" "phone" ];
    #         autoAccept = true;
    #         id = "Productivity";
    #       };
    #     };
    #   };
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
