{ pkgs, lib, ... }: {

  # Inspired by https://github.com/haennes/dotfiles/blob/cfd036748b91636106deb7cbdfdc9ba8cc95c5b8/users/hannses/idle.nix#L2
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
