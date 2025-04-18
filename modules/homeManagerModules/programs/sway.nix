{pkgs,osConfig,...}:
let
  modKey = "Mod4";
in
{

  # FIXME: you could also apply a condition, saying (if target machine is a NixOS machine, then assert this condition).
  # Or, you could just 'osConfig.security.polkit.enable = true;'
  assertions = [
    {
      assertion = osConfig.security.polkit.enable or false;
      message = "Sway requires Polkit to be enabled. Please enable 'security.polkit.enable' in your NixOS system configuration.";
    }
  ];
  programs.swaylock.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    # wrapperFeatures.gtk = true;
    extraConfig = ''
      # exec sleep 5; systemctl --user start kanshi.service

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

      # For Thinkpad Yoga 11e Trackpad:
      input "Elan Touchpad" {
          left_handed enabled
          tap enabled
          natural_scroll disabled
          dwt enabled
          accel_profile "flat" # disable mouse acceleration (enabled by default; to set it manually, use "adaptive" instead of "flat")
          pointer_accel 0.9 # set mouse sensitivity (between -1 and 1)
      }

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
      # For assigns, use wl-prop
      assign [app_id="Slack"] workspace 3
      assign [title="(?i).*slack.*"] workspace 3
      assign [class="[Pp]lexamp" title="[Pp]lexamp"] workspace 3
      assign [title="KDE Connect SMS"] workspace 10
      assign [title="KDE Connect"] workspace 10
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
          command = "swaymsg exec 'kdeconnect-app'";
        }
        {
          command = "swaymsg exec kdeconnect-sms'";
        }
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
