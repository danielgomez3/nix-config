# thunderbird.nix - put this in a separate file to test
{
  config,
  pkgs,
  ...
}: {
  # Enable Thunderbird with a default profile
  home.packages = [pkgs.thunderbird];
  programs.thunderbird = {
    enable = false;
    #   profiles.default = {
    #     isDefault = true;
    #   };
    # };

    # # Configure your email account
    # accounts.email.accounts = {
    #   "user1@danielgomezcoder.org" = {
    #     address = "user1@danielgomezcoder.org";
    #     realName = "Your Name";
    #     passwordCommand = "echo 'poopy'";
    #     primary = true;

    #     # IMAP (receiving emails)
    #     imap = {
    #       host = "mail.danielgomezcoder.org";
    #       port = 993;
    #       tls.enable = true;
    #     };

    #     # SMTP (sending emails)
    #     smtp = {
    #       host = "mail.danielgomezcoder.org";
    #       port = 465;
    #       tls.enable = true;
    #     };

    #     # Enable in Thunderbird
    #     thunderbird.enable = true;
    #   };
  };
}
