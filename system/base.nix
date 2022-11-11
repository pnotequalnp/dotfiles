{ config, lib, pkgs, inputs, ... }:

{
  time.timeZone = lib.mkDefault "America/Los_Angeles";

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  environment = {
    systemPackages = with pkgs; [ acpi curl git tmux neovim ];
    etc."nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
  };

  nix = {
    package = pkgs.nixUnstable;

    registry.nixpkgs.flake = inputs.nixpkgs;

    gc = {
      automatic = false;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];

      auto-optimise-store = true;
      keep-derivations = true;
      keep-outputs = true;
      warn-dirty = true;

      trusted-users = [ "root" "@wheel" ];
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  users = {
    mutableUsers = true;

    users.kevin = {
      shell = pkgs.zsh;
      isNormalUser = true;
      extraGroups =
        [ "wheel" "networkmanager" "dialout" "docker" "vboxusers" "wireshark" ];
      initialHashedPassword = "";
    };
  };

  systemd = {
    targets.network-online.wantedBy = pkgs.lib.mkForce [ ];
    services.NetworkManager-wait-online.wantedBy = pkgs.lib.mkForce [ ];
  };

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  networking.hostId = builtins.substring 0 8
    (builtins.hashString "sha256" config.networking.hostName);
}
