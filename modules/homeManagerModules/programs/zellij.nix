{
  pkgs,
  lib,
  ...
}: {
  programs.zellij = {
    enable = true;
    settings = {
      default_mode = "locked";
      scrollback_editor = "hx";
      pane_frames = false;
      keybinds = {
        locked = {
          # "bind \"Alt i\"" = {
          # };
          "bind \"Alt [\"" = {
            SwitchToMode = ["entersearch"];
          };

          "bind \"Alt j\"" = {
            EditScrollback = [];
          };
          "bind \"Alt \\\\\"" = {
            ToggleFloatingPanes = [];
          };
          # "bind \"Alt ]\"" = {
          #   MoveTab = ["Right"];
          # };
          # "bind \"Alt [\"" = {
          #   MoveTab = ["Left"];
          # };
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
          "bind \"Alt z\"" = {
            FocusNextPane = [];
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

        # Doesn't work: make 'w' key (picking the manager) in locked mode automatically
        # session = {
        #   "bind \"w\"" = {
        #     SwitchToMode = ["locked"];
        #   };
        # };
        # tab = {
        #   "bind \"Alt ]\"" = {
        #     MoveTab = ["Right"];
        #   };
        #   "bind \"Alt [\"" = {
        #     MoveTab = ["Left"];
        #   };
        # };
      };
    };
  };
}
