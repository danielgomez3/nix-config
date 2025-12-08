# TODO: ignore 'result'?
{
  pkgs,
  lib,
  ...
}: {
  programs.fzf = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = true;
    # Fzf widgets
    # defaultCommand = "${lib.getExe pkgs.fd} --strip-cwd-prefix=always --exclude .git";
    changeDirWidgetCommand = "${lib.getExe pkgs.fd} --type d --follow --hidden --exclude '.*' --exclude .git --strip-cwd-prefix=always --base-directory .";
    # fileWidgetCommand = "${lib.getExe pkgs.fd} --type f --follow --exclude .git --strip-cwd-prefix=always --base-directory ../";
    fileWidgetCommand = "${lib.getExe pkgs.fd} --type f --follow --exclude .git --strip-cwd-prefix=always --base-directory .";
  };
}
