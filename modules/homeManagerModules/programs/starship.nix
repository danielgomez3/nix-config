{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      format = "$time\n$all";
      # right_format = lib.concatStrings [
      #   "$time"
      # ];
      time = {
        disabled = false;
        format = "🕒 [$time]($style)";
        use_12hr = true;
        # time_format = "%H:%M:%S";
        style = "bold dimmed white";
      };
      cmd_duration = {
        format = "underwent [ $duration ]";
        disabled = false;
        min_time = 0;
        show_milliseconds = false;
        # style = accent_style;
      };
    };
  };
}
