{pkgs,lib,...}:{

  services.swayidle = {
    enable = true;
    package = pkgs.swayidle; # Default package, can be customized if needed
    timeouts = [
      {
        timeout = 10;
        command = "swaymsg 'output * dpms off'";
        resumeCommand = "swaymsg 'output * dpms on'"; # Optional: Restore screen when activity resumes
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
