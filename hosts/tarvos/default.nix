{ config, ... }:

{
  imports = [ ./hardware.nix ];

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

  services = {
    kmonad.keyboards.${config.networking.hostName}.device =
      "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

    btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/main" ];
    };

    upower.enable = true;
  };
}
