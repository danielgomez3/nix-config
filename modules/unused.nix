{ config, pkgs, lib, inputs, username, ... }:

{
    home-manager = { 
      users.${username} = {
        programs = {
          zellij = {
            enable = true;
            # settings = {
            #   default_mode = "locked";
            #   pane_frames = false;
            #   theme = "default";
            #   # theme = "tokyo-night-storm";
            #   # default_layout = "default_zjstatus"; # previously "compact"
            #   scrollback_editor = "hx";
            #   themes = {
            #     default = {
            #       bg = "#403d52";
            #       fg = "#e0def4";
            #       red = "#eb6f92";
            #       green = "#31748f";
            #       blue = "#9ccfd8";
            #       yellow = "#f6c177";
            #       magenta = "#c4a7e7";
            #       orange = "#fe640b";
            #       cyan = "#ebbcba";
            #       black = "#26233a";
            #       white = "#e0def4";
            #     };
            #   };
            #   # keybinds = {
            #   #   locked = {
            #   #     bind = [
            #   #       "Alt h" '' {SwitchToMode 'Normal'}; ''
            #   #     ];
            #   #   };
            #   # };
            # };
          };
        };
      };
    };
}
