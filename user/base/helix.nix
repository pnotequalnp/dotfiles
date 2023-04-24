{ config, pkgs, lib, inputs, ... }:

{
  home.sessionVariables.EDITOR = lib.getExe config.programs.helix.package;

  programs.helix = {
    enable = true;
    # package = inputs.helix.packages.${pkgs.system}.default;

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

        # rainbow-brackets = true;

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

    languages = [
      {
        name = "nix";
        language-server.command = lib.getExe inputs.nil.packages.${pkgs.system}.default;
      }
      { name = "haskell";
        config = {
           haskell.formattingProvider = "fourmolu";
        };
      }
      {
        name = "cabal";
        scope = "source.cabal";
        injection-regex = "cabal";
        file-types = ["cabal"];
        roots = ["*.cabal"];
        comment-token = "--";
        language-server = { command = "haskell-language-server-wrapper"; args = ["--lsp"]; };
        indent = { tab-width = 2; unit = "  "; };
      }
      {
        name = "java";
        language-server.command = lib.getExe pkgs.jdt-language-server;
      }
    ];
  };
}
