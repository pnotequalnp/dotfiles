{ config, ... }:

let
  colors = config.colorScheme.hashedColors;
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
        background-color: ${colors.base01};
      }

      #input {
        background-color: ${colors.base01};
        color: ${colors.base05}
      }

      #text {
        color: ${colors.base05};
      }

      #entry:selected {
        background-color: ${colors.base02};
      }
  '';
  };
}