{ pkgs }:
pkgs.writeShellScriptBin "my-awesome-script" 
# This is important because it will contain the hash for each package:
# ${pkgs.}/bin/ 
'' 
echo "hello world" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
''
