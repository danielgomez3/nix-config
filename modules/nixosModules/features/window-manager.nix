{ config, pkgs, lib, inputs, ... }:
let
  modKey = "Mod4";
  username = config.myVars.username;
in
{
  
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Brighness and volume <https://nixos.wiki/wiki/Sway>
  users.users.${username}.extraGroups = [ "video" ];
  programs = {
    light.enable = true;
  };

  security.rtkit.enable = true;  # Necessary for Pipewire

  # For Wayland/Sway screen-sharing:
  xdg.portal = {
    config.common.default = "*";
    enable = true;
    wlr = {
      enable = true;
      settings = {
        screencast = {
          max_fps = 15;
          chooser_type = "dmenu";
          chooser_cmd = "${pkgs.wofi}/bin/wofi --show dmenu";
        };
      };
    };
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  services = { 
    gnome.gnome-online-accounts.enable = true;
    gnome.gnome-keyring.enable = true;

  };

  # hardware.graphics.enable = true;  # NOTE: Enable this if you have problems with sway
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };
  # security.pam.services.gdm = {};
  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Source Han Serif" ];
      sansSerif = [ "Noto Sans" "Source Han Sans" ];
    };
  };

  home-manager.users.${username} = {
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
        # exec sway-audio-idle-inhibit
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
      '';
      config = {
        modifier = "${modKey}";
        terminal = "wezterm";
        startup = [
          { command = "slack"; }
          { command = "pavucontrol"; }
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
  };
}
