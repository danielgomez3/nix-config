
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ username, pkgs, ... }:

{
  users.users.${username} = {
    description = "server";
  };
  users.users.deploy = {
    description = "Dedicated, isolated, and privileged user with admin privileges to deploy configs";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
    ignoreShellProgramCheck = true;

  };
  # Make sure user 'deploy' has paswordless sudo permissions:
  security.sudo.extraConfig = ''
    deploy ALL=(ALL) NOPASSWD: ALL
  '';
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
    virtualization = {
      enable = true;
    };
    plex = {
      enable = true;
      openFirewall = true;
      user = "${username}";
      # dataDir = "/home/${username}/plex";
    };
    syncthing = {
      guiAddress = "0.0.0.0:8384";
      settings.gui = {
        user = "${username}";
        # FIXME: This is bad. This is a unique password tho.
        password = "naruto88";  
      };
    };
  };


  # home-manager = { 
  #   extraSpecialArgs = { inherit inputs; };
  #   users.${username} = {
  #     programs = with pkgs; {
  #       kitty = {
  #         font = {
  #           size = 11;
  #         };
  #       };
  #     };
  #   };
  #   packages = with pkgs; [
  #     hello
  #   ];

  # };

}
