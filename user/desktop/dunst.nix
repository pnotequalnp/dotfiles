{ config, ... }:
let
  colors = config.colorScheme.hashedColors;
in {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "mouse";
        notification_limit = 6;
        offset = "8x8";
        layer = "overlay";
        gap_size = 6;
        corner_radius = 4;
        frame_width = 1;
        markup = "full";
      };

      urgency_critical = {
        background = colors.base01;
        foreground = colors.base05;
        frame_color = colors.base08;
      };

      urgency_low = {
        background = colors.base01;
        foreground = colors.base05;
        frame_color = colors.base0A;
      };

      urgency_normal = {
        background = colors.base01;
        foreground = colors.base05;
        frame_color = colors.base04;
      };
      };
  };
}