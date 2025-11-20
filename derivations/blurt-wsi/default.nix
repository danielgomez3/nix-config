{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  name = "A package to make the blurt installation reproducible";
  src = fetchFromGitHub {
    owner = "QuantiusBenignus";
    repo = "BlahST";
    rev = "main"; # Use specific commit for reproducibility
    sha256 = "sha256-RVZT2iknpAdRElwEmnv+V16vx5ltGPjV0PSC1b3v8Gw=";
  };
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    cp $src/wsi $out/bin/
    chmod +x $out/bin/wsi
  '';
}
