# derivations/blurt-transcribe/default.nix
{pkgs}:
pkgs.stdenv.mkDerivation {
  name = "blurt-transcribe-wrapper";

  buildInputs = [pkgs.whisper-cpp];

  phases = ["installPhase"];

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${pkgs.whisper-cpp}/bin/whisper-cli $out/bin/transcribe
  '';
}
