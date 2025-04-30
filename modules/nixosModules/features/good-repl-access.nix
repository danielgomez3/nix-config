# https://nixos.wiki/wiki/Flakes
{inputs,...}:{
  nix.nixPath = [
        "repl=${inputs.self.outPath}/repl.nix"
        "nixpkgs=${inputs.nixpkgs}"
      ];
    # let
    #   path = toString ../../..;
    #   # path = "${inputs.self.outPath}";
    # in
}
