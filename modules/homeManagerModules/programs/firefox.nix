{
  pkgs,
  lib,
  ...
}: {
  # NixOS agnostic, but not implemented for now

  programs.firefox = {
    enable = false;
    # NOTE For any theming to be applied, you need to tell this module which profiles you're using:
    profiles = {
      daniel = {
        # bookmarks, extensions, search engines...
      };
    };
  };
}
