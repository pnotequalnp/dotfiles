{ config, lib, pkgs, inputs, ... }:

{
  time.timeZone = lib.mkDefault "America/Los_Angeles";

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  environment = {
    systemPackages = with pkgs; [ acpi curl git vim ];
    etc."nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
  };

  documentation.nixos.enable = false;

  nix = {
    package = pkgs.nixUnstable;

    registry.nixpkgs.flake = inputs.nixpkgs;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];

      auto-optimise-store = true;
      keep-derivations = true;
      keep-outputs = true;
      warn-dirty = false;

      trusted-users = [ "root" "@wheel" ];
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;

  users = {
    mutableUsers = false;

    users.root.shell = pkgs.fish;

    users.kevin = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups =
        [ "wheel" "networkmanager" "dialout" "docker" "vboxusers" "wireshark" "video" ];
      passwordFile = config.sops.secrets.user_password.path;
    };
  };


  sops = {
    age = {
      keyFile = "/var/lib/key.age";
      sshKeyPaths = [];
    };

    gnupg.sshKeyPaths = [];

    secrets.user_password = {
      sopsFile = ./secrets.yaml;
      neededForUsers = true;
    };
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  networking.hostId = builtins.substring 0 8
    (builtins.hashString "sha256" config.networking.hostName);
}
