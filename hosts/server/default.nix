
# server.nix
# NOTE: This contains all common features I want only my server to have!

{ username, ... }:

{
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
