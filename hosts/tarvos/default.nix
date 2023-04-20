{ config, lib, pkgs, ... }:

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

  services = {
    greetd.settings.initial_session = {
      command = "Hyprland";
      user = "kevin";
    };

    kmonad.keyboards.${config.networking.hostName}.device =
      "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/main" ];
    };

    upower.enable = true;
  };

  systemd.services.muteLight = {
    description = "Disable mute light";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${lib.getExe pkgs.light} -s sysfs/leds/platform::mute -S 0
        ${lib.getExe pkgs.light} -s sysfs/leds/platform::micmute -S 0
      '';
    };
  };

  hardware.bluetooth.enable = true;
  
  zramSwap = {
    enable = lib.mkDefault true;
    algorithm = "zstd";
  };
}
