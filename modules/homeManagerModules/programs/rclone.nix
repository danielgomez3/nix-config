{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.rclone = {
    enable = true;
    remotes.gdrive = {
      config = {
        type = "drive";
        # drive_type = "business";
      };
      secrets = {
        token = config.age.secrets."google_drive/token".path;
      };
    };
  };
}
