{pkgs, inputs, ...}:
let
    system = "x86_64-linux";
in {

  # Via this command: sox -d $(pocketsphinx soxflags) | pocketsphinx -
  home.packages = [
    # pocketsphinx  # live voice speach recogn.
    # sox  # convert audio files, effects, filters,etc
  ];
}

