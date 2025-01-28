let
    nixpkgs = import (builtins.getFlake "nixpkgs") {};
in
{

nixpkgs = nixpkgs; # Expose nixpkgs as a top-level attribute

isPubSshKey = x: (builtins.match ".*\\.pub$") x != null;  # Left is evaluated first
filesIn = dir: (map (fname: dir + "/${fname}")
  (builtins.attrNames (builtins.readDir dir)));

dirsIn = dir:
  nixpkgs.lib.filterAttrs (name: value: value == "directory")
  (builtins.readDir dir);

}
