
{pkgs,...}:{
  # Console
  console =
  {
    font = "ter-132n";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  # TTY
  fonts.fonts = with pkgs; [ meslo-lgs-nf ];
  services.kmscon =
  {
    enable = true;
    hwRender = true;
    extraConfig =
    ''
      font-name=MesloLGS NF
      font-size=14
    '';
  };

  # Boot
  boot =
  {
    # Plymouth
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
    kernelParams = [ "quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail" ];

    # Boot Loader
    loader =
    {
      timeout = 0;
    };
  };
}
