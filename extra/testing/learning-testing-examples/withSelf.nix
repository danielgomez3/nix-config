# NOTE: Failed attempt at debugging with 'self'.
{
  description = "Example for using 'self'";

  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }: let
    pkgs = import nixpkgs { system = "x86_64-linux"; };
    isPublicSshKey = x: (builtins.match ".*\\.pub$") x != null;
  in {
    default = {
      nixpkgs = nixpkgs; # Expose nixpkgs as a top-level attribute.
      self = self;  # Expose 'self' as well.

      listOfPublicKeys = builtins.filter 
        (x: isPublicSshKey (builtins.toString x))
        (pkgs.lib.filesystem.listFilesRecursive ./.);

      funcPublicUserSshKeys = searchableDir:
        builtins.filter 
          (x: isPublicSshKey (builtins.toString x))
          (pkgs.lib.filesystem.listFilesRecursive searchableDir);

      filesIn = dir: (map (fname: dir + "/${fname}")
        (builtins.attrNames (builtins.readDir dir)));

      dirsIn = dir:
        pkgs.lib.filterAttrs (name: value: value == "directory")
        (builtins.readDir dir);
    };
  };
}
