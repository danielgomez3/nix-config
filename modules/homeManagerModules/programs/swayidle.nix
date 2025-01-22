{ config, pkgs, lib, ... }: {

  services.swayidle = {
    enable = true;

    timeouts = lib.mkMerge [
      (lib.mkIf config.myVars.isHardwareLimited [
        {
          timeout = 120;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 220;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ])
      (lib.mkIf (!config.myVars.isHardwareLimited) [
        {
          timeout = 250;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 300;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ])
    ];

    events = [{
      event = "lock";
      command = "${pkgs.swaylock}/bin/swaylock -fF";
    }];
  };

}
