{pkgs,lib,...}:{ 
  home.packages = with pkgs; [
    fira-code-nerdfont
  ];

  programs.wezterm = {
    enable = true;
    # package = inputs.wezterm.packages.${pkgs.system}.default;
    extraConfig = ''
      return {
        -- HACKME: see if can remove in future NixOS version or patch
        front_end = "WebGpu",  
        hide_tab_bar_if_only_one_tab = true,
        -- font = wezterm.font("Fira Code"),
        -- font = wezterm.font_with_fallback({
        --   -- { family = "Fira Code", style = "Normal" },
        --   { family = "Fira Code Nerd Font Mono", style = "Normal" },
        --   { family = "Hack Nerd Font", style = "Normal" },
        --   { family = "Cambria Math" },
        -- }),
        font = wezterm.font_with_fallback({'Firacode Nerd Font Mono','Droid Sans Fallback'})

      }
    '';
  };
}
