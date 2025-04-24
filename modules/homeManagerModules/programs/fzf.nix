{pkgs,lib,...}:{

  programs.fzf = { 
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
  };

}
