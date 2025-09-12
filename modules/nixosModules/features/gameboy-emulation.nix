{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (retroarch.withCores (cores:
      with cores; [
        genesis-plus-gx
        snes9x
        beetle-psx-hw
      ]))
  ];
}
