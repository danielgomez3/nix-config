{...}: {
  services = {
    libinput.touchpad.disableWhileTyping = true;
    syncthing = {
      guiAddress = "127.0.0.1:8383";
    };
  };

  services.xserver = {
    xkb.options = "caps:swapescape";
  };
}
