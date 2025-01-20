{pkgs,lib,...}:{

  programs.zellij = {
    enable = true;
    settings = {
      default_mode = "locked";
      scrollback_editor = "hx";
      pane_frames = false;
      keybinds = {
        locked = {
          "bind \"Alt l\"" = {
            GoToNextTab = [];
          };
          "bind \"Alt h\"" = {
            GoToPreviousTab = [];
          };
          "bind \"Alt r\"" = {
            SwitchToMode = ["renametab"];
            TabNameInput = [0];
          };
          # "bind \"Alt r\"" = {
          #   NewTab = [];
          #   SwitchToMode = ["renametab"];
          #   TabNameInput = [0];
          # };
        };
        renametab = {
          "bind \"Enter\"" = {
            SwitchToMode = ["locked"];
          };
        };
        tab = {
          "bind \"Alt ]\"" = {
            MoveTab = ["Right"];
          };
          "bind \"Alt [\"" = {
            MoveTab = ["Left"];
          };
        };
      };
    };
  };
}
