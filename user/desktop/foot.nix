{ config, ... }:

let
  colors = config.colorScheme.palette;
in {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Iosevka Arc:style=Light Condensed:size=13";
        pad = "6x3";
      };
      colors = {
          background = colors.base00;
          foreground = colors.base05;
          regular0 = colors.base00;
          regular1 = colors.base08;
          regular2 = colors.base0B;
          regular3 = colors.base0A;
          regular4 = colors.base0D;
          regular5 = colors.base0E;
          regular6 = colors.base0C;
          regular7 = colors.base05;
          bright0 = colors.base03;
          bright1 = colors.base08;
          bright2 = colors.base0B;
          bright3 = colors.base0A;
          bright4 = colors.base0D;
          bright5 = colors.base0E;
          bright6 = colors.base0C;
          bright7 = colors.base07;
      };
    };
  };
}
