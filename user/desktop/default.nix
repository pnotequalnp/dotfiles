{ pkgs, lib, config, inputs, ... }:

let
  swaylock = lib.getExe pkgs.swaylock;
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  light = lib.getExe' pkgs.light "light";
in {
  imports = [
    ./hyprland.nix
    ./ashell.nix
    ./wofi.nix
    ./dunst.nix
    ./alacritty.nix
    ./firefox.nix
    ./discord.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    anki
    bitwarden
    blueman
    brightnessctl
    element-desktop
    foliate
    gimp
    grim
    imv
    (iosevka.override { privateBuildPlan = "${./iosevka.toml}"; set = "Arc"; })
    libnotify
    mpv
    networkmanagerapplet
    noto-fonts-emoji
    obsidian
    pavucontrol
    rquickshare
    slurp
    udiskie
    wdisplays
    wl-clipboard
    wlr-randr
    yubikey-manager-qt
    yubioath-flutter
  ];

  fonts.fontconfig.enable = true;

  home.pointerCursor = {
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-macchiato-mauve-compact";
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        size = "compact";
        variant = "macchiato";
      };
    };
  };

  services = {
    batsignal.enable = true;

    udiskie = {
      enable = true;
      tray = "never";
    };
    
    swayidle = {
      enable = true;
      systemdTarget = "hyprland-session.target";
      events = [
        {
          event = "before-sleep";
          command = "${loginctl} lock-session";
        }
        {
          event = "lock";
          command = "${swaylock} -efu -i ${inputs.self}/images/lock.png";
        }
        {
          event = "after-resume";
          command = "${light} -I; ${hyprctl} dispatch dpms on";
        }
      ];
      timeouts = [
        {
          timeout = 150;
          command = "${light} -O; ${light} -T 0.25";
          resumeCommand = "${light} -I";
        }
        {
          timeout = 300;
          command = "${hyprctl} dispatch dpms off";
          resumeCommand = "${hyprctl} dispatch dpms on";
        }
        {
          timeout = 360;
          command = "${loginctl} lock-session";
        }
        {
          timeout = 900;
          command = "${systemctl} suspend";
        }
      ];
    };
  };
}
