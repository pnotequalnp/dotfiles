{ pkgs, config, lib, ... }:

let host = config.networking.hostName;
in {
  programs = {
    hyprland.enable = true;

    light.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  
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
          compose.key = "compose";
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

  xdg.portal.config.common.default = "*";
}
