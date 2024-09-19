{ stdenv, lib, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "public-keys";

  src = ./.;

  buildInputs = [ stdenv ];

  buildPhase = ''
    mkdir -p $out
    for key in keys/*.pub; do
      cp $key $out/
    done
  '';

  installPhase = ''
    mkdir -p $out
    cp -r keys/*.pub $out/
  '';
}
