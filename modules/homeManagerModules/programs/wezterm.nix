{pkgs,lib,...}:{ 
  programs.wezterm = {
    enable = true;
    # package = inputs.wezterm.packages.${pkgs.system}.default;
    extraConfig = ''
      return {
        -- HACKME: see if can remove in future NixOS version or patch
        front_end = "WebGpu",  
        hide_tab_bar_if_only_one_tab = true
      }
    '';
  };
}
