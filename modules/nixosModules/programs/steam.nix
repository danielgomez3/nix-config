# desktop-gaming.nix
{
  lib,
  config,
  ...
}: {
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; # start games in an optimized microcompositor
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.gamemode.enable = true; # improve performance by requesting optimizations for (steam?) game processes and OS.

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
}
