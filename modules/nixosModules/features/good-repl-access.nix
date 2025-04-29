{inputs,...}:{
  nix.nixPath =
    let
      path = toString ./.;
    in
      [
        "repl=${inputs.self.outPath}/repl.nix" "nixpkgs=${inputs.nixpkgs}"
      ];
}
