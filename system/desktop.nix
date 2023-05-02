{ pkgs, config, lib, ... }:

let host = config.networking.hostName;
in {
  programs = {
    hyprland.enable = true;

    light.enable = true;
  };
  
  services = {
    greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session.command = "${lib.getExe pkgs.greetd.tuigreet} --cmd Hyprland";
      };
    };

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

    udisks2.enable = true;
  };

  security = {
    rtkit.enable = true;

    pam.services.swaylock.text = "auth include login";
  };
}
