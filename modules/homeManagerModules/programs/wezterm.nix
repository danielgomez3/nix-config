{pkgs,lib,...}:{ 
  programs.wezterm = {
    enable = true;
    # package = inputs.wezterm.packages.${pkgs.system}.default;
    extraConfig = ''
      return {
        front_end = "WebGpu",  -- HACKME: see if can remove in future NixOS version or patch
        enable_tab_bar = false,
      }
    '';
  };
}
