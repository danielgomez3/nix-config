{pkgs, inputs, ...}:{

  # Via this command: sox -d $(pocketsphinx soxflags) | pocketsphinx -
  home.packages = with pkgs; [
    # pocketsphinx  # live voice speach recogn.
    # sox  # convert audio files, effects, filters,etc
    # inputs.nerd-dictation.packages.${system}.default
    inputs.nerd-dictation
  ];
}
