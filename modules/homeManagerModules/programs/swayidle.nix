{pkgs,lib,...}:{

  services.swayidle = {
    enable = true;
    package = pkgs.swayidle; # Default package, can be customized if needed
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock";
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
    extraArgs = [ "-w" ]; # Default, keeps swayidle alive while sway is running
    systemdTarget = "sway-session.target"; # Adjust target if needed
  };

}
