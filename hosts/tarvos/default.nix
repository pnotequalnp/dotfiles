{ lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../system/development.nix
  ];

  system.stateVersion = "20.03";

  networking = {
    hostName = "tarvos";

    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  sops.defaultSopsFile = ./secrets.yaml;

  keyboards = [
    { name = "built-in"; device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd"; }
    { name = "usb"; device = "/dev/input/by-id/usb-dakai_PS_2+USB_Keyboard-event-kbd"; }
  ];

  services = {
    greetd.settings.initial_session = {
      command = "Hyprland";
      user = "kevin";
    };

    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/main" ];
    };

    upower.enable = true;
  };

  programs.steam = {
    enable = true;
    package = pkgs.steam.override { extraPkgs = p: with p; [ openssl ]; };
  };

  home-manager.users.kevin = {
    home.packages = [ pkgs.audacity ];
  };

  systemd.services.mute-light =
    let
      light = lib.getExe' pkgs.light "light";
    in {
      description = "Disable mute light";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = (pkgs.writeShellScript "mute-light" ''
          ${light} -s sysfs/leds/platform::mute -S 0
          ${light} -s sysfs/leds/platform::micmute -S 0
        '').outPath;
    };
  };

  hardware.bluetooth.enable = true;
  
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = "zstd";
  };
}
