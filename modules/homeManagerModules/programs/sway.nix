{pkgs,lib,...}:
let
  modKey = "Mod4";
in
{

  programs.swaylock.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    # wrapperFeatures.gtk = true;
    extraConfig = ''
      # exec sleep 5; systemctl --user start kanshi.service
      workspace number 1
      exec sleep 1; swaymsg workspace 1  # Ensure workspace 1 is selected after startup

      # Brightness
      bindsym XF86MonBrightnessDown exec light -U 10
      bindsym XF86MonBrightnessUp exec light -A 10

      # Volume
      bindsym XF86AudioRaiseVolume exec pamixer -i 5 && pamixer --get-volume
      bindsym XF86AudioLowerVolume exec pamixer -d 5 && pamixer --get-volume
      bindsym XF86AudioMute exec pamixer --toggle-mute 

      # Lock laptop if lid is closed
      set $lock '${pkgs.swaylock}/bin/swaylock -fF'
      bindswitch --reload --locked lid:on exec $lock

      

      #bindsym $mod+n exec 'flashfocus --flash'
      for_window [class="^.*"] border pixel 0
      titlebar_border_thickness 0
      titlebar_padding 0

      input * {
        xkb_options caps:escape
      }


      # Functionality
      no_focus [all]
      focus_on_window_activation none
      assign [app_id="Slack"] workspace 3
      assign [title="(?i).*slack.*"] workspace 3
      assign [class="[Pp]lexamp" title="[Pp]lexamp"] workspace 3
      assign [title="KDE Connect SMS"] workspace 2
      assign [title="Volume Control"] workspace 10
      bindsym ${modKey}+Semicolon exec --no-startup-id flash_window
    '';
    config = {
      # assigns = {
      #   "3" = [{}];
      # };
      modifier = "${modKey}";
      terminal = "wezterm";
      startup = [
        # { command = "slack"; }
        {
          command = "swaymsg exec '${pkgs.pavucontrol}/bin/pavucontrol'";
        }
        {
          command = "${pkgs.autotiling}/bin/autotiling";
          always = true;
        }
        {
          command = "${pkgs.flashfocus}/bin/flashfocus";
          always = true;
        }
        {
          command = "${pkgs.wayland-pipewire-idle-inhibit}/wayland-pipewire-idle-inhibit";
          always = true;
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
