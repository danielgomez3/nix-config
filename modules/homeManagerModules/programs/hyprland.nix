{pkgs,lib,...}:{
  wayland.windowManager.hyprland = {
    enable = false;
    xwayland.enable = false;
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        # Move window position
        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        "$mod,Return,exec,kitty"
        # "$mod SHIFT,Return,exec,kitty"
        "$mod SHIFT,Q,killactive"   # Close the current window with SUPER+Q
        "$mod SHIFT,E,exit"   # Close the current window with SUPER+Q
        "$mod, F, fullscreen"
        "$mod,R,exec,wofi --show drun"
        # Switch workspaces with mainMod [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod, bracketright, workspace, e+1"
        "$mod, bracketleft, workspace, e-1"
        # Move active window to a workspace with mainMod SHIFT [0-9]
        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
        "$mod SHIFT, 0, movetoworkspacesilent, 10"
        "$mod SHIFT, bracketleft, movetoworkspace, -1"
        "$mod SHIFT, bracketright, movetoworkspace, +1"
        # Move/Resize windows with mainMod LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        # "$mod, mouse:273, resizewindow"
      ];
      exec-once = [
        "slack"
        "kdeconnect-sms"
        "plexamp"
        "firefox"
        "pavucontrol"
      ];
      windowrule = [
        "workspace 1 silent, firefox"
        "workspace 2 silent, Slack"
        "workspace 3 silent, org.kde.kdeconnect.sms"
        "workspace 10 silent, Plexamp"
        "workspace 10 silent, pavucontrol"
      ];

      # listener = [
      #   {
      #     timeout = 15;
      #     on-timeout = "systemctl suspend";
      #   }          
      # ];
      general = {
          layout = "master";
        };
      };
    # extraConfig = ''
    # '';
  };
  
}
