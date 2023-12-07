{
  programs.git = {
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

    delta.enable = true;
  };
}
