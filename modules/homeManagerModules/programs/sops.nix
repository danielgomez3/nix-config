{
  pkgs,
  lib,
  inputs,
  ...
}: let
  secretspath = builtins.toString inputs.mysecrets;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  # WIP:
  # sops = {
  #   defaultSopsFile = "${secretspath}/secrets.yaml";
  #   defaultSopsFormat = "yaml";
  # };
}
