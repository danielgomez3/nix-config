{ osConfig, pkgs, lib, ... }: {

  services.swayidle = {
    enable = true;
    timeouts = lib.mkMerge [  # Command to run after 'timeout-seconds' of inactivity
      (lib.mkIf osConfig.myVars.isHardwareLimited [
        {
          timeout = 120;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 220;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ])
      # Default settings if condition not true:
      [
        {
          timeout = 250;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 300;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ]
    ];

    events = [
      { event = "lid"; command = "${pkgs.swaylock}/bin/swaylock -fF && ${pkgs.systemd}/bin/systemctl suspend"; }
    ];
  };

}
