{pkgs, ...}: {
  # nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.allowUnfreePredicate = _: true;
  # home.packages = [
  #   pkgs.google-chrome
  # ];
  programs.chromium = {
    enable = true;
    # homepageLocation = "https://www.startpage.com/";
    # extensions = [
    #   "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx" # dark reader
    #   "aapbdbdomjkkjkaonfhkkikfgjllcleb;https://clients2.google.com/service/update2/crx" # google translate
    # ];
    # extraOpts = {
    #   "WebAppInstallForceList" = [
    #     {
    #       "custom_name" = "Youtube";
    #       "create_desktop_shortcut" = false;
    #       "default_launch_container" = "window";
    #       "url" = "https://youtube.com";
    #     }
    #   ];
    # };
  };
}
