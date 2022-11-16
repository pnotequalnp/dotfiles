{ lib, pkgs, ... }:

let
  workspace = n: let
    key = builtins.toString (lib.mod (n + 1) 10);
    ws = builtins.toString (n + 1);
    ws' = builtins.toString (n + 11);
  in ''
    bind = $mod, ${key}, workspace, ${ws}
    bind = $mod SHIFT, ${key}, movetoworkspacesilent, ${ws}
    bind = $mod CTRL, ${key}, workspace, ${ws'}
    bind = $mod CTRL SHIFT, ${key}, movetoworkspacesilent, ${ws'}
  '';
  workspaces = builtins.concatStringsSep "\n" (builtins.genList workspace 10) + ''
    bind = $mod, grave, togglespecialworkspace
    bind = $mod SHIFT, grave, movetoworkspace, special
  '';
  direction = { key, dir }: ''
    bind = $mod, ${key}, movefocus, ${dir}
    bind = $mod SHIFT, ${key}, movewindow, ${dir}
  '';
  directions = builtins.concatStringsSep "\n" (builtins.map direction [
    {key = "h"; dir = "l";}
    {key = "j"; dir = "d";}
    {key = "k"; dir = "u";}
    {key = "l"; dir = "r";}
  ]);
in {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      $mod = SUPER

      general {
        gaps_in = 2
        gaps_out = 4
        cursor_inactive_timeout = 3
        no_cursor_warps = true
      }

      input {
        accel_profile = flat
        sensitivity = 0
        follow_mouse = 2
        touchpad {
          natural_scroll = true
        }
      }

      binds {
        workspace_back_and_forth = true
      }

      decoration {
        rounding = 4
        
        blur_new_optimizations = 1
      }

      misc {
        disable_hyprland_logo = true
      }

      ${directions}

      ${workspaces}

      bind = $mod, space, exec, wofi -S drun

      bind = $mod, return, exec, alacritty
      bind = $mod CTRL, return, exec, firefox

      bind = $mod CTRL, escape, killactive,

      bind = , Print, exec, slurp | grim -g - - | wl-copy -t image/png
    '';
  };
}