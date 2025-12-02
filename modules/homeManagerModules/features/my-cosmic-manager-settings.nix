# cosmic-manager.nix
{
  inputs,
  config,
  ...
}: let
in {
  # imports = [
  #   inputs.cosmic-manager.homeManagerModules.cosmic-manager
  # ];

  # # COSMIC Desktop declarative configuration must be enabled
  # wayland.desktopManager.cosmic.enable = true;

  # # The COSMIC compositor configuration.
  # wayland.desktopManager.cosmic.compositor = {
  #   active_hint = true;
  #   autotile = true;
  #   autotile_behavior = config.lib.cosmic.mkRON "enum" "Global"; # Automatic tiling behavior. If set to Global, autotile applies to all windows in all workspaces. If set to PerWorkspace, autotile only applies to new windows, and new workspaces.
  #   cursor_follows_focus = false; # Whether the cursor should follow the focused window.
  #   descale_xwayland = false;
  #   edge_snap_threshold = 0;
  #   focus_follows_cursor = false;
  #   focus_follows_cursor_delay = 250;
  #   workspaces = {
  #     workspace_layout = config.lib.cosmic.mkRON "enum" "Vertical";
  #     workspace_mode = config.lib.cosmic.mkRON "enum" "OutputBound";
  #   };
  #   xkb_config = {
  #     layout = "br";
  #     model = "pc104";
  #     options = config.lib.cosmic.mkRON "optional" "terminate:ctrl_alt_bksp";
  #     repeat_delay = 600;
  #     repeat_rate = 25;
  #     rules = "";
  #     variant = "dvorak";
  #   };
  # };

  # programs.cosmic-applibrary.enable = true;

  # # Configuration entries for COSMIC Application Library.
  # programs.cosmic-applibrary.settings = {
  #   # Configuration entries for COSMIC Application Library.
  #   groups = [
  #     {
  #       # The filter of the group. Type: RON enum variant “None” (singular RON enum) or RON enum variant “AppIds” with 1 list of string value (singular RON tuple enum) or RON named struct of (open submodule of attribute set of anything) or raw RON value
  #       filter = config.lib.cosmic.mkRON "namedStruct" {
  #         name = "Categories";
  #         value = {
  #           categories = [
  #             "Office"
  #           ];
  #           exclude = [];
  #           include = [
  #             "org.gnome.Totem"
  #             "org.gnome.eog"
  #             "simple-scan"
  #             "thunderbird"
  #           ];
  #         };
  #       };
  #       icon = "folder-symbolic";
  #       name = "cosmic-office";
  #     }
  #     {
  #       filter = config.lib.cosmic.mkRON "enum" {
  #         value = [
  #           "Counter-Strike 2"
  #         ];
  #         variant = "AppIds";
  #       };
  #       icon = "folder-symbolic";
  #       name = "Games";
  #     }
  #   ];
  # };

  # programs.cosmic-edit.enable = true;
  # programs.cosmic-edit.settings = {
  #   # app_theme = config.lib.cosmic.mkRON "enum" "System";
  #   auto_indent = true;
  #   find_case_sensitive = false;
  #   find_use_regex = false;
  #   find_wrap_around = true;
  #   font_name = "Fira Mono";
  #   font_size = 16;
  #   highlight_current_line = true;
  #   line_numbers = true;
  #   # syntax_theme_dark = "COSMIC Dark";
  #   # syntax_theme_light = "COSMIC Light";
  #   tab_width = 2;
  #   vim_bindings = true;
  #   word_wrap = true;
  # };

  # programs.cosmic-files.enable = true;
  # programs.cosmic-files.settings = {
  #   app_theme = config.lib.cosmic.mkRON "enum" "System";
  #   desktop = {
  #     show_content = true;
  #     show_mounted_drives = false;
  #     show_trash = false;
  #   };
  #   favorites = [
  #     (config.lib.cosmic.mkRON "enum" "Home")
  #     (config.lib.cosmic.mkRON "enum" "Documents")
  #     (config.lib.cosmic.mkRON "enum" "Downloads")
  #     (config.lib.cosmic.mkRON "enum" "Music")
  #     (config.lib.cosmic.mkRON "enum" "Pictures")
  #     (config.lib.cosmic.mkRON "enum" "Videos")
  #     (config.lib.cosmic.mkRON "enum" {
  #       value = [
  #         "/home/user/Projects"
  #       ];
  #       variant = "Path";
  #     })
  #   ];
  #   show_details = false;
  #   tab = {
  #     folders_first = true;
  #     icon_sizes = {
  #       grid = 100;
  #       list = 100;
  #     };
  #     show_hidden = false;
  #     # view = config.lib.cosmic.mkRON "enum" "List";
  #   };
  # };

  # # The panels that will be displayed on the desktop.
  # wayland.desktopManager.cosmic.panels = [
  #   {
  #     anchor = config.lib.cosmic.mkRON "enum" "Bottom"; # The position of the panel on the screen. Type: null or one of the following RON enum variants: “Bottom”, “Left”, “Right”, “Top” or raw RON value
  #     anchor_gap = true;
  #     autohide = config.lib.cosmic.mkRON "optional" {
  #       # Whether the panel should autohide and the settings for autohide. If set the value is set to null, the panel will not autohide.
  #       handle_size = 4;
  #       transition_time = 200;
  #       wait_time = 1000;
  #     };
  #     background = config.lib.cosmic.mkRON "enum" "Dark";
  #     expand_to_edges = true;
  #     margin = 4;
  #     name = "Panel";
  #     opacity = 1.0;
  #     output = config.lib.cosmic.mkRON "enum" {
  #       value = [
  #         "Virtual-1"
  #       ];
  #       variant = "Name";
  #     };
  #     plugins_center = config.lib.cosmic.mkRON "optional" [
  #       "com.system76.CosmicAppletTime"
  #     ];
  #     plugins_wings = config.lib.cosmic.mkRON "optional" (config.lib.cosmic.mkRON "tuple" [
  #       [
  #         "com.system76.CosmicPanelWorkspacesButton"
  #         "com.system76.CosmicPanelAppButton"
  #         "com.system76.CosmicAppletWorkspaces"
  #       ]
  #       [
  #         "com.system76.CosmicAppletInputSources"
  #         "com.system76.CosmicAppletStatusArea"
  #         "com.system76.CosmicAppletTiling"
  #         "com.system76.CosmicAppletAudio"
  #         "com.system76.CosmicAppletNetwork"
  #         "com.system76.CosmicAppletBattery"
  #         "com.system76.CosmicAppletNotifications"
  #         "com.system76.CosmicAppletBluetooth"
  #         "com.system76.CosmicAppletPower"
  #       ]
  #     ]);
  #     size = config.lib.cosmic.mkRON "enum" "M";
  #   }
  # ];

  # # Defines a list of custom shortcuts for the COSMIC desktop environment. Each shortcut specifies a key combination, the action to be performed, and optionally a description for a custom shortcut.
  # wayland.desktopManager.cosmic.shortcuts = [
  #   {
  #     action = config.lib.cosmic.mkRON "enum" {
  #       value = [
  #         "firefox"
  #       ];
  #       variant = "Spawn";
  #     };
  #     description = config.lib.cosmic.mkRON "optional" "Open Firefox";
  #     key = "Super+B";
  #   }
  #   {
  #     action = config.lib.cosmic.mkRON "enum" "Close";
  #     key = "Super+Q";
  #   }
  #   {
  #     action = config.lib.cosmic.mkRON "enum" "Disable";
  #     key = "Super+M";
  #   }
  #   {
  #     action = config.lib.cosmic.mkRON "enum" {
  #       value = [
  #         (config.lib.cosmic.mkRON "enum" "BrightnessDown")
  #       ];
  #       variant = "System";
  #     };
  #     key = "XF86MonBrightnessDown";
  #   }
  #   {
  #     action = config.lib.cosmic.mkRON "enum" {
  #       value = [
  #         (config.lib.cosmic.mkRON "enum" "Launcher")
  #       ];
  #       variant = "System";
  #     };
  #     key = "Super";
  #   }
  # ];

  # # Overrides for COSMIC Desktop system actions.
  # wayland.desktopManager.cosmic.systemActions = config.lib.cosmic.mkRON "map" [
  #   {
  #     key = config.lib.cosmic.mkRON "enum" "Terminal";
  #     value = "wezterm";
  #   }
  #   {
  #     key = config.lib.cosmic.mkRON "enum" "Launcher";
  #     value = "krunner";
  #   }
  # ];
}
