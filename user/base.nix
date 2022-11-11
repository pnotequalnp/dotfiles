{ pkgs, ... }:

{
  home.packages = with pkgs; [ fd ripgrep ];

  programs = {
    nushell = {
      enable = true;
      configFile.source = ./nu/config.nu;
      envFile.source = ./nu/env.nu;
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
        nix_shell = {
          symbol = " ";
          format = "[$symbol]($style) ";
        };
        hostname.format = "[$hostname]($style):";
        username.format = "[$user]($style)@";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userName = "Kevin Mullins";
      userEmail = "kevin@pnotequalnp.com";

      aliases = {
        graph =
          "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) %C(white)[%G?]%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
        full-graph =
          "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) %C(white)[%G?]%C(reset) - %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
      };

      ignores = [ ".direnv/" ".envrc" "result" "result-doc" ];

      extraConfig = {
        pull.ff = "only";
        init.defaultBranch = "main";
        github.user = "pnotequalnp";
        tag.gpgSign = true;
        safe.directory = "*";
      };

      signing = {
        signByDefault = true;
        key = "3FE1845783ADA7CB";
      };
    };

    ssh = {
      enable = true;
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

    helix = {
      enable = true;
      settings = {

      };
    };

    bat.enable = true;
    exa.enable = true;
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
