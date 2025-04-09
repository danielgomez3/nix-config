{pkgs,lib,...}:{
  # NOTE: Necessary for simple remote building of nix-on-droid system
  # https://github.com/nix-community/nix-on-droid/wiki/Simple-remote-building
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

}
