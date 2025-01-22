{ config, pkgs, lib, ... }:

{
  # Swayidle configuration
  # Inspired by https://github.com/haennes/dotfiles/blob/cfd036748b91636106deb7cbdfdc9ba8cc95c5b8/users/hannses/idle.nix#L2
  services.swayidle = {
    enable = true;

    # Conditional timeouts based on isHardwareLimited
    timeouts = lib.mkIf config.myVars.isHardwareLimited
      [ # Shorter timeouts for hardware-limited devices
        {
          timeout = 100;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 150;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ]
      [ # Default timeouts for non-hardware-limited devices
        {
          timeout = 250;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 300;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];

    # Events (unchanged)
    events = [{
      event = "lock";
      command = "${pkgs.swaylock}/bin/swaylock -fF";
    }];
  };
}
