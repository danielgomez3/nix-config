{ pkgs, lib, ... }: {

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 10;
        command = "${pkgs.swaylock}/bin/swaylock -fF";
      }
      {
        timeout = 20;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    events = [{
      event = "lock";
      command = "${pkgs.swaylock}/bin/swaylock -fF";
    }];
  };

}
