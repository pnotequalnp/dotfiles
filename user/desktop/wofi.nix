{ config, ... }:

let
  inherit (config.colorScheme) colors;
  hash = color: "#${color}";
in {
  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      insensitive = true;
      allow_images = true;
      allow_markup = true;
      no_actions = true;
      prompt = "";
      key_up = "Control_L-p";
      key_down = "Control_L-n";
    };

    style = ''
      * {
        font-family: Iosevka;
      }
  
      #window {
        background-color: ${hash colors.base01};
      }

      #input {
        background-color: ${hash colors.base01};
        color: ${hash colors.base05}
      }

      #text {
        color: ${hash colors.base05};
      }

      #entry:selected {
        background-color: ${hash colors.base02};
      }
  '';
  };
}