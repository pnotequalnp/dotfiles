{ config, lib, pkgs, ... }:

{
  networking = {
    useDHCP = false;
    networkmanager.enable = true;
    firewall.checkReversePath = "loose";
  };

  sops.secrets.ssh_host_key = {};

  services = {
    openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
      };

      hostKeys = [{
        path = config.sops.secrets."ssh_host_key".path;
        type = "ed25519";
      }];
    };

    tailscale.enable = true;
  };
}
