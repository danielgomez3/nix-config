# derivations/mySws/default.nix
{ stdenv }:

stdenv.mkDerivation {
  name = "my-website";
  
  # Either use a src directory containing your files
  src = ./src;  # Looks in the same directory as this file
  
  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
    # Or for the direct approach:
    # cp $indexHtml $out/index.html
  '';
}
