{pkgs,lib,...}:
let
  modKey = "Mod4";
in
{

  wayland.windowManager.sway = {
    enable = true;
    # wrapperFeatures.gtk = true;
    extraConfig = ''
      # exec sleep 5; systemctl --user start kanshi.service
      workspace number 1
      bindsym XF86MonBrightnessDown exec light -U 10
      bindsym XF86MonBrightnessUp exec light -A 10

      #bindsym $mod+n exec 'flashfocus --flash'
      for_window [class="^.*"] border pixel 0
      titlebar_border_thickness 0
      titlebar_padding 0

      input * {
        xkb_options caps:escape
      }


      # Vanity
      exec_always --no-startup-id flashfocus
      exec_always autotiling

      # Functionality
      no_focus [all]
      focus_on_window_activation none
      #assign [class="[Ss]lack"] title=[".*Slack.*"] workspace 2
      #assign [class="[Ss]potify" title="[Ss]potify"] workspace 2
      assign [app_id="Slack"] workspace 2
      assign [title="(?i).*slack.*"] workspace 2
      assign [class="[Pp]lexamp" title="[Pp]lexamp"] workspace 2
      assign [title="KDE Connect SMS"] workspace 2
      assign [title="Volume Control"] workspace 10
      bindsym ${modKey}+Semicolon exec --no-startup-id flash_window

      # Prevent lockscreen when audio is playing TODO: put in dedicated area:
      #exec wayland-pipewire-idle-inhibit 
    '';
    config = {
      modifier = "${modKey}";
      terminal = "wezterm";
      startup = [
        { command = "slack"; }
        { command = "pavucontrol"; }
        {
          command = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit";
          always = false;
        }
        # { command = "${pkgs.sway-audio-idle-inhibit}/bin/sway-audio-idle-inhibit"; }
      ];
      # keybindings
      bars = [
        {
          extraConfig = ''
            bar {
              position top
              mode hide 
              status_command while date +'%Y-%m-%d %X'; do sleep 1; done
              colors {
                statusline #ffffff
                background #323232
                inactive_workspace #32323200 #32323200 #5c5c5c
              }
            }
          '';
        }
      ];
    };
  };   
 
}
