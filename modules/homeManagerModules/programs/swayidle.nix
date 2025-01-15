{
pkgs,
config,
...
}:
let
  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  sleep = "${pkgs.coreutils}/bin/sleep";
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";

  isLocked = "${pgrep} -x ${swaylock}";
  lockTime = 10; 

  # Makes two timeouts: one for when the screen is not locked (lockTime+timeout) and one for when it is.
  afterLockTimeout =
    { timeout
    , command
    , resumeCommand ? null
    ,
    }: [
      {
        timeout = lockTime + timeout;
        inherit command resumeCommand;
      }
      {
        command = "${isLocked} && ${command}";
        inherit resumeCommand timeout;
      }
    ];
  in
{
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    timeouts =
      # Lock screen
      [
        {
          timeout = lockTime;
          command = "${sleep} 1 && ${swaylock} --daemonize";
        }
      ]
      ++
      # Mute mic
      (afterLockTimeout {
        timeout = 5;
        command = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
        resumeCommand = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
      })
      ++
      # Suspend the system
      [
        {
          timeout = lockTime + 10;
          command = "${isLocked} && systemctl suspend";
        }
      ];
  };

}

