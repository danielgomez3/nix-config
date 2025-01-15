{pkgs,lib,...}:{

  services.sway = {
    enable = true;
    config = {
      idle = {
        enabled = true;
        timeout = {
          "10s" = "swaymsg 'output * dpms off'";
          "20s" = "systemctl suspend";
        };
      };
    };
  };

}
