{
  config,
  pkgs,
  ...
}: let
  basePreferences = {
    "accessibility.typeaheadfind.enablesound" = false; # Disable bell in ctrl-f
    # Other universal preferences...
    "sidebar.verticalTabs" = true; # FIXME this isn't working?
  };

  limitedHardwarePrefs =
    basePreferences
    // {
      "layout.css.devPixelsPerPx" = "0.9";
    };
in {
  programs.firefox = {
    enable = true;
    preferences =
      if config.myVars.isHardwareLimited or false
      then limitedHardwarePrefs
      else basePreferences;
  };
}
