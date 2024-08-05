
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
  services = {
    syncthing = {
      guiAddress = "0.0.0.0:8384";
      settings = {
        devices = {
          "desktop" = { 
            id = "DKS7OX6-YYTR72D-4PJ63ME-YJW6BTP-MIKV64F-7K6IOM5-757VTON-NVGTAQC"; 
            autoAcceptFolders = true;
          };
          "pixel" = { 
            id = "L4PI6U7-VTRHUSU-WLSC3GV-EHWG4QX-DMSNSEL-DVACMSN-7D2EOIT-AIREAAZ"; 
            autoAcceptFolders = true;
          };
        };
        folders = {
          "Documents" = {         # Name of folder in Syncthing, also the folder ID
            path = "/home/${username}/Documents";    # Which folder to add to Syncthing
            devices = [ "desktop" ];      # Which devices to share the folder with
            id = "aaa-xxx";
          };
          "Productivity" = {
            path = "/home/${username}/Productivity";
            devices = [ "desktop" "pixel" ];
            id = "bbb-xxx";
          };
          "Projects" = {
            path = "/home/${username}/Projects";
            devices = [ "desktop" ];
            id = "ccc-xxx";
          };
          "flake" = {
            path = "/home/${username}/flake";
            devices = [ "desktop" ];
            id = "ddd-xxx";
          };
        };
      };
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
