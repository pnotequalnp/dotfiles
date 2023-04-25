{ config, ... }:
let
  inherit (config.colorScheme) colors;
  hash = color: "#${color}";
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
        background = hash colors.base01;
        foreground = hash colors.base05;
        frame_color = hash colors.base08;
      };

      urgency_low = {
        background = hash colors.base01;
        foreground = hash colors.base05;
        frame_color = hash colors.base0A;
      };

      urgency_normal = {
        background = hash colors.base01;
        foreground = hash colors.base05;
        frame_color = hash colors.base04;
      };
      };
  };
}