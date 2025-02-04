{pkgs,...}:{

  # Via this command: sox -d $(pocketsphinx soxflags) | pocketsphinx -
  home.packages = with pkgs; [
    pocketsphinx  # live voice speach recogn.
    sox  # convert audio files, effects, filters,etc
  ];
}
