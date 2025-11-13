# server-with-lid.nix
# https://discourse.nixos.org/t/prevent-laptop-from-suspending-when-lid-is-closed-if-on-ac/12630/4
{...}: {
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
  };
}
