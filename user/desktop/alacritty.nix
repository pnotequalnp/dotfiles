{ config, ... }:

let
  colors = config.colorScheme.hashedColors;
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
          background = colors.base00;
          foreground = colors.base05;
        };
        
        cursor = {
          text = colors.base00;
          cursor = colors.base05;
        };
        
        normal = {
          black = colors.base00;
          red = colors.base08;
          green = colors.base0B;
          yellow = colors.base0A;
          blue = colors.base0D;
          magenta = colors.base0E;
          cyan = colors.base0C;
          white = colors.base05;
        };

        bright = {
          black = colors.base03;
          red = colors.base08;
          green = colors.base0B;
          yellow = colors.base0A;
          blue = colors.base0D;
          magenta = colors.base0E;
          cyan = colors.base0C;
          white = colors.base07;
        };
      };
    };
  };
}
