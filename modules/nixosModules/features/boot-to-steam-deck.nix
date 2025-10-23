# boot-on-steam-deck.nix
# NOTE: this is untested
{
  pkgs,
  config,
  ...
}: let
  username = config.myVars.username;
  gsScript = pkgs.writeShellScriptBin "gs" ''
    #!/usr/bin/env bash
    set -xeuo pipefail

    gamescopeArgs=(
        --adaptive-sync
        --hdr-enabled
        --mangoapp
        --rt
        --steam
    )
    steamArgs=(
        -pipewire-dmabuf
        -tenfoot
    )
    mangoConfig=(
        cpu_temp
        gpu_temp
        ram
        vram
    )
    mangoVars=(
        MANGOHUD=1
        MANGOHUD_CONFIG="$(IFS=,; echo "''${mangoConfig[*]}")"
    )

    export "''${mangoVars[@]}"
    exec gamescope "''${gamescopeArgs[@]}" -- steam "''${steamArgs[@]}"
  '';
in {
  boot.kernelPackages = pkgs.linuxPackages; # (this is the default) some amdgpu issues on 6.10
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
  hardware.xone.enable = true; # support for the xbox controller USB dongle
  services.getty.autologinUser = username;
  environment = {
    systemPackages = [pkgs.mangohud pkgs.gsScript];
    loginShellInit = ''
      [[ "$(tty)" = "/dev/tty1" ]] && gs
    '';
  };
}
