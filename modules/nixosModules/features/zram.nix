# zram.nix
# https://saylesss88.github.io/installation/enc/enc_install.html?highlight=luks#what-does-luks-encryption-protect
{
  lib,
  config,
  ...
}: let
in {
  zramSwap = {
    enable = true;
    # one of "lzo", "lz4", "zstd"
    algorithm = "zstd";
    priority = 5;
    memoryPercent = 50;
  };
}
