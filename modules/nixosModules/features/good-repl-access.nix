# https://nixos.wiki/wiki/Flakes
# This allows for:
# This will launch a 'nix repl' with access to nixpkgs, lib, and the flake options in a split of a second, instead of manually loading it in or doing some acrobatics in the justfile or with args.
{inputs,...}:{
  nix.nixPath =
    let
      path = toString ./.;
    in
      [
        "repl=${inputs.self.outPath}/repl.nix" "nixpkgs=${inputs.nixpkgs}"
      ];
}
