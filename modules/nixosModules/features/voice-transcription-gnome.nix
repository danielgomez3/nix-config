# voice-transcription-gnome.nix
{
  pkgs,
  config,
  inputs,
  ...
}: let
  wsi = pkgs.callPackage "${inputs.self.outPath}/derivations/blurt-wsi" {};
  transcribe = pkgs.callPackage "${inputs.self.outPath}/derivations/blurt-transcribe" {};
in {
  environment.systemPackages = with pkgs; [
    gnomeExtensions.blurt
    # deps:
    whisper-cpp # not necessary?
    transcribe
    sox
    xsel
    curl
  ];
  home-manager.users.${config.myVars.username} = {
    dconf.settings = {
      "org/gnome/shell" = {
        enabled-extensions = [
          pkgs.gnomeExtensions.blurt.extensionUuid
        ];
      };

      "org/gnome/shell/extensions/blurt" = {
        whisper-path = "${wsi}/bin/";
      };
    };
  };
}
