{ lib, config, ... }:

let
  colors = config.colorScheme.palette;
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
    
    bind = $mod CTRL ALT, ${builtins.toString n}, focusmonitor, ${builtins.toString n}
    bind = $mod ALT, ${builtins.toString n}, movecurrentworkspacetomonitor, ${builtins.toString n}
  '';
  workspaces = builtins.concatStringsSep "\n" (builtins.genList workspace 10) + ''
    bind = $mod, grave, togglespecialworkspace
    bind = $mod SHIFT, grave, movetoworkspace, special
  '';
  direction = { key, dir, resize }: ''
    bind = $mod, ${key}, movefocus, ${dir}
    bind = $mod SHIFT, ${key}, movewindow, ${dir}
    bind = $mod CTRL, ${key}, moveintogroup, ${dir}
    bind = $mod CTRL SHIFT, ${key}, moveoutofgroup, ${dir}

    bind = $mod ALT, ${key}, moveactive, ${resize}
    bind = $mod ALT SHIFT, ${key}, resizeactive, ${resize}
  '';
  directions = builtins.concatStringsSep "\n" (builtins.map direction [
    {key = "h"; dir = "l"; resize = "-50 0";}
    {key = "j"; dir = "d"; resize = "0 50";}
    {key = "k"; dir = "u"; resize = "0 -50";}
    {key = "l"; dir = "r"; resize = "50 0";}
  ]);
in {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.variables = [ "--all" ];
    extraConfig = ''
      $mod = SUPER

      monitor = eDP-1, preferred, auto, 1
      monitor = HDMI-A-1, preferred, auto-up, 1

      general {
        gaps_in = 2
        gaps_out = 4
        
        col.inactive_border = ${rgb colors.base03}
        col.active_border = ${rgb colors.base05}
      }

      input {
        accel_profile = flat
        sensitivity = 0
        follow_mouse = 2
        touchpad {
          natural_scroll = true
        }
        kb_options = compose:menu
      }

      binds {
        workspace_back_and_forth = true
      }

      group {
        col.border_active = ${rgb colors.base05}
        col.border_inactive = ${rgb colors.base03}

        groupbar {
          render_titles = false
          scrolling = false
          height = 0
          col.active = ${rgb colors.base05}
          col.inactive = ${rgb colors.base03}
        }
      }

      decoration {
        rounding = 4
        blur {
          enabled = false
        }
        shadow {
          enabled = false
        }
      }

      misc {
        disable_hyprland_logo = true
      }
      
      dwindle {
        force_split = 2
      }

      workspace = w[tv1], gapsout:0, gapsin:0
      workspace = f[1], gapsout:0, gapsin:0
      windowrulev2 = bordersize 0, floating:0, onworkspace:w[tv1]
      windowrulev2 = rounding 0, floating:0, onworkspace:w[tv1]
      windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
      windowrulev2 = rounding 0, floating:0, onworkspace:f[1]

      ${directions}

      ${workspaces}

      bindm = ALT, mouse:272, movewindow
      
      bind = $mod, backspace, togglefloating
      bind = $mod SHIFT, backspace, centerwindow
      bind = $mod CTRL, backspace, pin

      bind = $mod, tab, togglegroup
      bind = $mod SHIFT, tab, moveoutofgroup
      bind = $mod, n, changegroupactive, b
      bind = $mod, e, changegroupactive, f

      bind = $mod, f, fullscreen, 1
      bind = $mod SHIFT, f, fullscreen, 0

      bind = $mod, space, exec, wofi -S drun

      bind = $mod, return, exec, foot
      bind = $mod CTRL, return, exec, firefox

      bind = $mod CTRL, escape, killactive,

      bind = , Print, exec, slurp -c 00000000 | grim -g - - | wl-copy -t image/png
    '';
  };
}
