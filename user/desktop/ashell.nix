{ inputs, ... }:
{
  systemd.user.services = {
    ashell = {
      Unit = {
        Description = "ashell status bar";
        PartOf = ["hyprland-session.target"];
      };

      Service = {
        ExecStart = "${inputs.ashell.defaultPackage.x86_64-linux}/bin/ashell";
        Restart = "on-failure";
      };

      Install.WantedBy = ["hyprland-session.target"];
    };
  };

  xdg.configFile."ashell/config.toml".source = ./ashell.toml;
}
