{ config, pkgs, lib, inputs, ... }:

{
  home.sessionVariables.EDITOR = lib.getExe config.programs.helix.package;

  programs.helix = {
    enable = true;

    settings = {
      theme = "catppuccin_macchiato";

      editor = {
        line-number = "relative";

        completion-replace = true;

        rulers = [100];

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        indent-guides = {
          render = true;
          rainbow = "dim";
        };

        whitespace = {
          render = {
            space = "none";
            nbsp = "all";
            tab = "all";
            newline = "all";
          };
          characters = {
            space = "·";
            nbsp = "⍽";
            tab = "→";
            newline = "⤶";
          };
       };

        lsp = {
          display-inlay-hints = true;
        };
      };
    };

    languages = {
      language = [
        {
          name = "cabal";
          scope = "source.cabal";
          injection-regex = "cabal";
          file-types = ["cabal"];
          roots = ["*.cabal"];
          comment-token = "--";
          language-servers = [ "haskell-language-server-wrapper" ];
          indent = { tab-width = 2; unit = "  "; };
        }
      ];

      language-server = {
          haskell-language-server.config.haskell.formattingProvider = "fourmolu";
      };
    };
  };
}
