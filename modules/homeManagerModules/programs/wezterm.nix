{
  pkgs,
  lib,
  ...
}: {
  programs.wezterm = {
    enable = true;
    # package = inputs.wezterm.packages.${pkgs.system}.default;
    extraConfig = ''
      return {

        window_decorations = "NONE",
        audible_bell = "Disabled",
        hide_tab_bar_if_only_one_tab = true,
        warn_about_missing_glyphs = false,  -- Disables missing glyph warnings
        font = wezterm.font_with_fallback({'FiraCode Nerd Font Mono','Droid Sans Fallback'}),
        -- font = wezterm.font_with_fallback({'Symbols Nerd Font', 'Droid Sans Fallback'}),

        keys = {
          -- Disable Alt+Enter (fullscreen toggle)
          { key = "Enter", mods = "ALT", action = wezterm.action.DisableDefaultAssignment },

        },

      }
    '';
  };
}
