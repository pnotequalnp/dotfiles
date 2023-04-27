{ lib, config, ... }:

let
  inherit (config.colorScheme) colors;
  rgb = c: "rgb(${c})";
  workspace = n: let
    key = builtins.toString (lib.mod (n + 1) 10);
    ws = builtins.toString (n + 1);
    ws' = builtins.toString (n + 11);
  in ''
    bind = $mod, ${key}, workspace, ${ws}
    bind = $mod SHIFT, ${key}, movetoworkspacesilent, ${ws}
    bind = $mod CTRL, ${key}, workspace, ${ws'}
    bind = $mod CTRL SHIFT, ${key}, movetoworkspacesilent, ${ws'}
    
    bind = $mod ALT, ${builtins.toString n}, focusmonitor, ${builtins.toString n}
    bind = $mod CTRL ALT, ${builtins.toString n}, movecurrentworkspacetomonitor, ${builtins.toString n}
  '';
  workspaces = builtins.concatStringsSep "\n" (builtins.genList workspace 10) + ''
    bind = $mod, grave, togglespecialworkspace
    bind = $mod SHIFT, grave, movetoworkspace, special
  '';
  direction = { key, dir }: ''
    bind = $mod, ${key}, movefocus, ${dir}
    bind = $mod SHIFT, ${key}, movewindow, ${dir}
    bind = $mod CTRL, ${key}, moveintogroup, ${dir}
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

      monitor = eDP-1, preferred, auto, 1

      general {
        gaps_in = 2
        gaps_out = 4
        cursor_inactive_timeout = 3
        no_cursor_warps = true
        
        col.inactive_border = ${rgb colors.base03}
        col.active_border = ${rgb colors.base05}

        col.group_border = ${rgb colors.base03}
        col.group_border_active = ${rgb colors.base05}
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
      
      dwindle {
        force_split = 2
      }

      ${directions}

      ${workspaces}
      
      bind = $mod, backspace, togglefloating
      bind = $mod SHIFT, backspace, centerwindow

      bind = $mod, tab, togglegroup
      bind = $mod SHIFT, tab, moveoutofgroup
      bind = $mod, n, changegroupactive, b
      bind = $mod, e, changegroupactive, f

      bind = $mod, f, fullscreen, 1
      bind = $mod SHIFT, f, fullscreen, 0

      bind = $mod, space, exec, wofi -S drun

      bind = $mod, return, exec, alacritty
      bind = $mod CTRL, return, exec, firefox

      bind = $mod CTRL, escape, killactive,

      bind = , Print, exec, slurp -c 00000000 | grim -g - - | wl-copy -t image/png
    '';
  };
}