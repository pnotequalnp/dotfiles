{ config, ... }:

let
  inherit (config.colorScheme) colors;
  hash = color: "#${color}";
in {
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "Iosevka";

      window.padding = {
        x = 6;
        y = 6;
      };

      colors = {
        primary = {
          background = hash colors.base00;
          foreground = hash colors.base05;
        };
        
        cursor = {
          text = hash colors.base00;
          cursor = hash colors.base05;
        };
        
        normal = {
          black = hash colors.base00;
          red = hash colors.base08;
          green = hash colors.base0B;
          yellow = hash colors.base0A;
          blue = hash colors.base0D;
          magenta = hash colors.base0E;
          cyan = hash colors.base0C;
          white = hash colors.base05;
        };

        bright = {
          black = hash colors.base03;
          red = hash colors.base08;
          green = hash colors.base0B;
          yellow = hash colors.base0A;
          blue = hash colors.base0D;
          magenta = hash colors.base0E;
          cyan = hash colors.base0C;
          white = hash colors.base07;
        };
      };
    };
  };
}
