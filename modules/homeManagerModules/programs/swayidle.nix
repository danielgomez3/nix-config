{ osConfig, pkgs, lib, ... }: {

  services.swayidle = {
    enable = true;

    timeouts = let
      default = [       
        {
          timeout = 250;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 300;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      hardwareLimited = [
        {
          timeout = 120;
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          timeout = 220;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    in
      lib.mkMerge [
        (lib.mkIf osConfig.myVars.isHardwareLimited hardwareLimited)
        default
      ];

    events = [
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
    ];
  };

}
