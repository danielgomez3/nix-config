{pkgs, ...}: {
  # services.xserver.desktopManager.retroarch.package = pkgs.retroarch-full;
  # services.xserver.desktopManager.retroarch.enable = true;
  # services.xserver.desktopManager.retroarch.extraArgs = [];
  environment.systemPackages = with pkgs; [
    (retroarch.withCores (cores:
      with cores; [
        genesis-plus-gx
        snes9x
        beetle-psx-hw
      ]))
  ];
}
