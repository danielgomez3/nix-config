### NOTE: Necessary for the REPL 
let
  pkgs = import <nixpkgs> {};
in
###
{
filesIn = dir: (map (fname: dir + "/${fname}")
  (builtins.attrNames (builtins.readDir dir)));

dirsIn = dir:
  pkgs.lib.filterAttrs (name: value: value == "directory")
  (builtins.readDir dir);
}
