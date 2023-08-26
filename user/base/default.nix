{ pkgs, lib, colorSchemes, ... }:

{
  imports = [
    ./fish.nix
    ./starship.nix
    ./git.nix
    ./helix.nix
    ./neofetch.nix
  ];

  home.packages = with pkgs; [
    fd
    file
    ripgrep
    unzip
    xdg-utils
    zip
  ];
  
  colorScheme =
    let
      scheme = colorSchemes.catppuccin-macchiato;
      hashedColors = lib.mapAttrs (_: color: "#${color}") scheme.colors;
    in scheme // { inherit hashedColors; };

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
    exa.enable = true;
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

  home.shellAliases = {
    ll = "exa -lFT --group-directories-first --color=always --git --git-ignore --icons --level 1";
    lla = "exa -laTF --group-directories-first --color=always --git --icons --level 1";
    llt = "exa -lTF --group-directories-first --color=always --git --git-ignore --icons";
    llta = "exa -laTF --group-directories-first --color=always --git --icons";
    ll2 = "exa -lTF --group-directories-first --color=always --git --git-ignore --icons --level 2";
    ll3 = "exa -lTF --group-directories-first --color=always --git --git-ignore --icons --level 3";
    ll4 = "exa -lTF --group-directories-first --color=always --git --git-ignore --icons --level 4";
    ll5 = "exa -lTF --group-directories-first --color=always --git --git-ignore --icons --level 5";
    ll2a = "exa -laTF --group-directories-first --color=always --git --icons --level 2";
    ll3a = "exa -laTF --group-directories-first --color=always --git --icons --level 3";
    ll4a = "exa -laTF --group-directories-first --color=always --git --icons --level 4";
    ll5a = "exa -laTF --group-directories-first --color=always --git --icons --level 5";
  };
}
