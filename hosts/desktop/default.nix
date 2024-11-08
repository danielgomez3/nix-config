{config, pkgs, ...}:
{
  
  time.hardwareClockInLocalTime = true;
  hardware.keyboard.zsa.enable = true;

  boot.blacklistedKernelModules = [
    # "iwlwifi"
    "rtw88_8821ce"
  ];
}
