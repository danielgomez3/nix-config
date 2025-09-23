{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.rclone.remotes.gdrive = {
    config = {
      type = "drive";
      # drive_type = "business";
    };
    secrets = {
      token = config.age.secrets."google_drive/token".path;
    };
  };
}
