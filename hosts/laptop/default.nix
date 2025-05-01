# laptop.nix
# NOTE: This contains all common features I want only my laptop to have!

{ config, pkgs, inputs, host, lib, ... }:

let 
  username = config.myVars.username;
in
{
  myVars.username = "daniel";
  myVars.hostname = "laptop";  # Specific hostname for this machine
  myVars.isHardwareLimited = true;
  myVars.isSyncthingClient = true;
  users.users.${username} = {
    description = "laptop";
  };

  myNixOS = {
    bundles.desktop-environment.enable = true;
    bundles.base-system.enable = true;
    qemu.enable = true;
    osx-kvm.enable = true;
    yubikey-functionality.enable = true;
    gpg.enable = true;
  };
  home-manager.users.${username}.myHomeManager = {
    bundles.desktop-environment.enable = true;
    bundles.coding-environment.enable = true;
  };

  services = {
    libinput.touchpad.disableWhileTyping = true;
    syncthing = {
      guiAddress = "127.0.0.1:8383";
    };
  };

  services.xserver = {
    xkb.options = "caps:swapescape";
  };
}
