{ pkgs }:
pkgs.stdenv.mkDerivation{
  name = "cutefetch";
  version = "0.0.3";
  src = pkgs.fetchFromGitHub {
    owner = "cybardev";
    repo = "cutefetch";
    rev = "9ed7cd87a89ab8f0f4b2b51fb8b4dd1ee64e46bf";
    sha256 = "sha256-j+gliFq7YX7i98nrS/JQTrHSytXP3GYCvd0dlPQPv8Y=";
  };
  # defines where the binary will be. Send it to $out/bin.
  installPhase = ''
  mkdir -p $out/bin
  cp cutefetch $out/bin
  '';
}
