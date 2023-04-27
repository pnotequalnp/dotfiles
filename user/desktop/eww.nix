{ config, lib, pkgs, ... }:

let
  eww = lib.getExe config.programs.eww.package;
  inherit (config.colorScheme) colors;
  hash = c: "#${c}";
  scripts = pkgs.rustPlatform.buildRustPackage {
    pname = "scripts";
    version = "0.1.0";
    src = ./eww/scripts;
    cargoLock.lockFile = ./eww/scripts/Cargo.lock;

    CRITICAL_COLOR = hash colors.base08;
    FULL_COLOR = hash colors.base0D;
    CHARGING_COLOR= hash colors.base0A;
    DISCHARGING_COLOR= hash colors.base08;
    EMPTY_COLOR = hash colors.base02;
    UNKNOWN_COLOR = hash colors.base02;
  };
  dependencies = with pkgs; [
    config.wayland.windowManager.hyprland.package
    scripts
    coreutils
  ];
in {
  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./eww/config;
  };

  xdg.configFile = {
    "eww".recursive = true;
    "eww/colors.scss".text = ''
      $base00: ${hash colors.base00}
      $base01: ${hash colors.base01}
      $base02: ${hash colors.base02}
      $base03: ${hash colors.base03}
      $base04: ${hash colors.base04}
      $base05: ${hash colors.base05}
      $base06: ${hash colors.base06}
      $base07: ${hash colors.base07}
      $base08: ${hash colors.base08}
      $base09: ${hash colors.base09}
      $base0A: ${hash colors.base0A}
      $base0B: ${hash colors.base0B}
      $base0C: ${hash colors.base0C}
      $base0D: ${hash colors.base0D}
      $base0E: ${hash colors.base0E}
      $base0F: ${hash colors.base0F}
    '';
  };

  systemd.user.services = {
    eww = {
      Unit = {
        Description = "Eww daemon";
        PartOf = ["hyprland-session.target"];
      };

      Service = {
        ExecStart = "${eww} daemon --no-daemonize";
        Restart = "on-failure";
        Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
      };

      Install.WantedBy = ["hyprland-session.target"];
    };
  };
}