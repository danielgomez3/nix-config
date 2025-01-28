let
    nixpkgs = import (builtins.getFlake "nixpkgs") {};
    isPublicSshKey = x: (builtins.match ".*\\.pub$") x != null;  # Left is evaluated first
in
{

nixpkgs = nixpkgs; # Expose nixpkgs as a top-level attribute

listOfPublicKeys = builtins.filter 
    (x: isPublicSshKey (builtins.toString x))
    (nixpkgs.lib.filesystem.listFilesRecursive ./.);

FuncPublicUserSshKeys = searchableDir :
  builtins.filter 
    (x: isPublicSshKey (builtins.toString x))
    (nixpkgs.lib.filesystem.listFilesRecursive searchableDir );

filesIn = dir: (map (fname: dir + "/${fname}")
  (builtins.attrNames (builtins.readDir dir)));

dirsIn = dir:
  nixpkgs.lib.filterAttrs (name: value: value == "directory")
  (builtins.readDir dir);

}
