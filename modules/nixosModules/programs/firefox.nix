{ config, pkgs, ... }:
let
  basePreferences = {
    "accessibility.typeaheadfind.enablesound" = false; # Disable bell in ctrl-f
    # Other universal preferences...
  };

  limitedHardwarePrefs = basePreferences // {
    "layout.css.devPixelsPerPx" = "0.9";
  };
in 
{

  # Force Firefox to use Wayland and set scaling
  # environment.sessionVariables = {
  #   MOZ_ENABLE_WAYLAND = "1";
  #   GDK_SCALE = "2";       # For GTK app scaling (if needed)
  #   GDK_DPI_SCALE = "0.5"; # Adjusts for high-DPI displays
  # };

  programs.firefox = {
    enable = true;
    preferences = if config.myVars.isHardwareLimited or false
                 then limitedHardwarePrefs
                 else basePreferences;
  };

}
