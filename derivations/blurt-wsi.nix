{
  stdenv,
  pkgs,
}:
stdenv.mkDerivation {
  pname = "A package to make the blurt installation reproducible";
  src = pkgs.fetchFromGitHub {
    owner = "QuantiusBenignus";
    repo = "BlahST";
    sha256 = pkgs.lib.fakeSha256;
  };
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src/wsi $out/bin/
    chmod +x $out/bin/wsi
  '';
}
