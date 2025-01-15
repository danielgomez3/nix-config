{ pkgs, lib, ... }: {

  services.swayidle = {
    enable = true;
    package = pkgs.swayidle;
    events = [
      {
        event = "before-sleep";
        command = ""; # Disable redundant locking here
      }
    ];
    timeouts = [
      {
        timeout = 10;
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
      {
        timeout = 20;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    extraArgs = [ "-w" ];
    systemdTarget = "sway-session.target";
  };

}
