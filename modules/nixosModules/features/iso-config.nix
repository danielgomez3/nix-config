# iso-config.nix
# TODO
#   users.users.nixos = lib.mkForce {}; # Completely override/remove the nixos user
{inputs, ...}: {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
  ];
}
