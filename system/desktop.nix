{ config, lib, ... }:

let host = config.networking.hostName;
in {
  programs = {
    hyprland = {
      enable = true;
      package = null;
    };

    light.enable = true;
  };

  services = {
    kmonad = {
      enable = true;
      keyboards.${host} = {
        name = host;
        config = builtins.readFile ./main.kbd;
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = true;
        };
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

    pam.services.swaylock.text = "auth include login";
  };
}
