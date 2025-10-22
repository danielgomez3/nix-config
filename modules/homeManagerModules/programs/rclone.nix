{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
  ...
}: {
  programs.rclone = {
    enable = true;
    remotes.daniel-new-remote = {
      config = {
        type = "drive";
        # drive_type = "business";
      };
      secrets = {
        # FIXME: the secret isn't deploying
        token = osConfig.sops.secrets."google_drive/token".path;
      };
    };
  };
}
