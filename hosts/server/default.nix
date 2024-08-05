
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ config, pkgs, lib, inputs, modulesPath, username, host, ... }:

{
  imports = [ ./hardware-configuration.nix ];  

  # NOTE: Unique configuration.nix content for server:
  # environment.systemPackages = with pkgs; [
  #   libsForQt5.kdenlive
  # ];

  users.users.${username} = {
    description = "server";
  };
  hardware.keyboard.zsa.enable = true;

  services = {
    coding = {
      enable = true;
      greeter = "${username}";
    };
    all = {
      enable = true;
      greeter = "${username}";
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
