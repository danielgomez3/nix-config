{pkgs,lib,...}:{ 
  wezterm = {
    enable = true;
    # package = inputs.wezterm.packages.${pkgs.system}.default;
    extraConfig = ''
      return {
        front_end = "WebGpu",  -- HACKME: see if can remove in future NixOS version or patch
        hide_tab_bar_if_only_one_tab = true,
      }
    '';
  };
}
