
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
    # syncthing = {
    #   guiAddress = "127.0.0.1:8380";
    #   settings = {
    #     devices = {
    #       "laptop" = { 
    #         id = "N4J2FSZ-DDQTYR2-RT6FC3Q-GKVPV66-MCMP2FD-6JDYI4P-JZYQR2L-OEOKHQW"; 
    #         autoAcceptFolders = true; 
    #       };
    #       "desktop" = { 
    #         id = "23GQV6A-ROUBBEV-N2S53WL-R6WJXFT-G2UKAXW-7D7C44A-USAGYXV-GW6WAQ2";
    #         autoAcceptFolders = true;
    #       };
    #       "phone" = {
    #         id = "L4PI6U7-VTRHUSU-WLSC3GV-EHWG4QX-DMSNSEL-DVACMSN-7D2EOIT-AIREAAZ";
    #         autoAcceptFolders = true; 
    #       };
    #     };
    #     folders = {
    #       "Documents" = {         
    #         path = "~/Documents";    
    #         devices = [ "laptop" ];      
    #       };
    #       "Productivity" = {         
    #         path = "~/Productivity";    
    #         devices = [ "laptop" "phone" ];      
    #       };
    #       "Projects" = {         
    #         path = "~/Projects";    
    #         devices = [ "laptop" ];      
    #       };
    #       "flake" = {         
    #         path = "~/flake";    
    #         devices = [ "laptop" ];      
    #       };
    #     };
    #   };
    # };
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
