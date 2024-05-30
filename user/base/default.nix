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
    dogdns
    duf
    fd
    file
    gping
    nix-output-monitor
    nix-tree
    procs
    ripgrep
    unzip
    xdg-utils
    xh
    zip
  ];
  
  colorScheme =
    let
      scheme = colorSchemes.catppuccin-macchiato;
      hashedColors = lib.mapAttrs (_: color: "#${color}") scheme.palette;
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
    eza.enable = true;
    jq.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gtk2;
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
    ll = "eza -lFT --group-directories-first --color=always --git --git-ignore --icons --level 1";
    lla = "eza -laTF --group-directories-first --color=always --git --icons --level 1";
    llt = "eza -lTF --group-directories-first --color=always --git --git-ignore --icons";
    llta = "eza -laTF --group-directories-first --color=always --git --icons";
    ll2 = "eza -lTF --group-directories-first --color=always --git --git-ignore --icons --level 2";
    ll3 = "eza -lTF --group-directories-first --color=always --git --git-ignore --icons --level 3";
    ll4 = "eza -lTF --group-directories-first --color=always --git --git-ignore --icons --level 4";
    ll5 = "eza -lTF --group-directories-first --color=always --git --git-ignore --icons --level 5";
    ll2a = "eza -laTF --group-directories-first --color=always --git --icons --level 2";
    ll3a = "eza -laTF --group-directories-first --color=always --git --icons --level 3";
    ll4a = "eza -laTF --group-directories-first --color=always --git --icons --level 4";
    ll5a = "eza -laTF --group-directories-first --color=always --git --icons --level 5";
  };
}
