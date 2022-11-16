{ pkgs, lib, inputs, ... }:

{
  programs.helix = {
    enable = true;
    package = inputs.helix.packages.${pkgs.system}.default;

    settings = {
      theme = "onedarker";

      editor = {
        line-number = "relative";

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

        rainbow-brackets = true;
       
        whitespace.render.tab = "all";
      };
    };

    languages = [{
      name = "nix";
      language-server.command = lib.getExe inputs.nil.packages.${pkgs.system}.default;
    }];
  };
}
