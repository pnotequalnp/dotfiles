{ config, lib, pkgs, ... }:

{
  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    firewall.checkReversePath = "loose";
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    tailscale.enable = true;
  };
}
