{ config, lib, ... }:

let host = config.networking.hostName;
in {
  services = {
    kmonad.keyboards.${host} = {
      enable = lib.mkDefault true;
      name = host;
      config = builtins.readFile ./main.kbd;
      defcfg = {
        enable = true;
        fallthrough = true;
        allowCommands = true;
      };
    };

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    upower.enable = true;

    pcscd.enable = true;

  };

  security = {
    rtkit.enable = true;
  };
}
