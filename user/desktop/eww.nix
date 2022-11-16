{ inputs, config, lib, pkgs, ... }:

let
  eww = lib.getExe config.programs.eww.package;
in {
  programs.eww = {
    enable = true;
    package = inputs.eww.packages.${pkgs.system}.eww-wayland;
    configDir = ./eww;
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
      };

      Install.WantedBy = ["hyprland-session.target"];
    };
  };
}