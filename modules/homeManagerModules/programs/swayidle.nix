{pkgs,lib,...}:{

  services.swayidle = {
    enable = true;
    package = pkgs.swayidle; # Default package, can be customized if needed
    timeouts = [
      {
        timeout = 10;
        # command = "swaymsg 'output * dpms off'";
        command = "${pkgs.swaylock}/bin/swaylock -fF"; # Lock the screen after 10 seconds
      }
      {
        timeout = 20;
        command = "systemctl suspend";
      }
    ];
    events = []; # Add events like locking the screen if needed
    extraArgs = [ "-w" ]; # Default, keeps swayidle alive while sway is running
    systemdTarget = "sway-session.target"; # Adjust target if needed
  };

}
