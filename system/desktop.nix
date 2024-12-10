{ pkgs, config, lib, ... }:

{
  options.keyboards = lib.mkOption {
    default = [];
  };

  config = {
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
        keyboards = builtins.listToAttrs (builtins.map ({name, device}: {
          inherit name;
          value = {
            inherit name device;
            config = builtins.readFile ./main.kbd;
            defcfg = {
              enable = true;
              fallthrough = true;
              allowCommands = true;
              compose.key = "compose";
            };
          };
        }) config.keyboards);
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

    xdg = {
      icons.enable = true;
      portal.config.common.default = "*";
    };

    fonts = {
      packages = with pkgs; [
        (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
        noto-fonts-emoji
      ];
    };
  };
}
