{pkgsUnstable, ...}: {
  # home.packages = with pkgsUnstable; [
  #    pay-respects
  # ];
  # programs.zsh.initExtra = ''
  #     eval "$(${pkgsUnstable.pay-respects}/bin/pay-respects zsh --alias)"
  #   '';
  # programs.zsh.shellAliases = {
  #   f= ''
  #     'eval $(_PR_LAST_COMMAND="$(fc -ln -1)" _PR_ALIAS="$(alias)" _PR_SHELL="zsh" "pay-respects")'
  #     '';
  # };
  programs.pay-respects = {
    enable = false;
    # package = pkgsUnstable.pay-respects;
    enableZshIntegration = true;
    options = [
      "--alias"
      "f"
    ];
  };
}
