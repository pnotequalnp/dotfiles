{ pkgs, ... }:

{

  imports = [ ./nushell.nix ./starship.nix ./git.nix ./helix.nix ./neofetch.nix ];

  home.packages = with pkgs; [ fd ripgrep ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    gpg = {
      enable = true;
      settings = {
        keyid-format = "long";
        with-fingerprint = false;
      };
    };

    ssh = {
      enable = true;
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

    bat.enable = true;
    bottom.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      desktop = "$HOME/";
      documents = "$HOME/documents";
      download = "$HOME/downloads";
      pictures = "$HOME/pictures";
    };
  };

}
