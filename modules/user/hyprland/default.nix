{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.userSettings.hyprland;
  #font = config.stylix.fonts.monospace.name;
  terminal = config.userSettings.terminal;
  spawnEditor = config.userSettings.spawnEditor;
  spawnBrowser = config.userSettings.spawnBrowser;
  spawnBrowserPrivate = config.userSettings.spawnBrowserPrivate;

  useNoctalia = config.userSettings.noctalia.enable;
  useWlogout = config.userSettings.wlogout.enable && !useNoctalia;

  lockCmd =
    if useNoctalia
    then "noctalia-shell ipc call lockScreen lock || hyprlock"
    else "hyprlock";

  sessionCmd =
    if useNoctalia
    then "noctalia-shell ipc call sessionMenu toggle || pkill wlogout || wlogout || hyprctl dispatch exit"
    else (if useWlogout
          then "pkill wlogout || wlogout || hyprctl dispatch exit"
          else "hyprctl dispatch exit");
in
{
  options = {
    userSettings.hyprland = {
      enable = lib.mkEnableOption "Enable hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      NIXOS_OZONE_WL = 1;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland,x11,*";
      QT_QPA_PLATFORM = "wayland;xcb";
      #QT_QPA_PLATFORMTHEME = lib.mkForce "qt5ct";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1.25";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
      CLUTTER_BACKEND = "wayland";
      #GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
      #GSK_RENDERER = "gl";
      XCURSOR_THEME = config.gtk.cursorTheme.name;
      GDK_DEBUG = "portals";
      GTK_USE_PORTALS = 1;
      #GRIM_DEFAULT_DIR = config.xdg.userDirs.extraConfig.XDG_SCREENSHOT_DIR;
    };

    xdg.portal =
    {
      enable = true;
      extraPortals = with pkgs;
        [
          xdg-desktop-portal
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
          #xdg-desktop-portal-termfilechooser
        ];
    };

    #xdg.portal.config.common = {
    #  default = [ "hyprland" ];
    #  "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
    #};
    #xdg.portal.config.hyprland = {
    #  default = [ "hyprland" ];
    #  "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
    #};

    #home.sessionVariables.TERMCMD = "kitty --class=filechoose_yazi";

    #xdg.configFile."xdg-desktop-portal-termfilechooser/config" =
    #{
    #  force = true;
    #  text =
    #  ''
    #    [filechooser]
    #    cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    #  '';
    #};

    wayland.windowManager.hyprland = {
      enable = true;
      #package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      plugins = [ ];
      settings = {
        "$mainMod" = "SUPER";

        source = "${config.xdg.configHome}/hypr/screen_profile.conf";

        env = [
          #"AQ_DRM_DEVICES,${config.home.sessionVariables.AQ_DRM_DEVICES}"
          #"AW_NO_MODIFIERS,1"
        ];
        exec-once =
          config.userSettings.desktop.startupApps
          ++ [
            "hyprctl setcursor ${config.gtk.cursorTheme.name} ${builtins.toString config.gtk.cursorTheme.size}"
            "wl-paste --type text --watch cliphist store"
            "wl-paste --type image --watch cliphist store"
            #"udiskie --tray"
            #"hypridle"
          ];

        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 3;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
          #no_cursor_warps = false;
        };

        #group = {
        #  "col.border_active" = config.wayland.windowManager.hyprland.settings.general."col.active_border";
        #  "col.border_inactive" = config.wayland.windowManager.hyprland.settings.general."col.inactive_border";
        #  groupbar = {
        #    gradients = false;
        #    #"col.active" = "0xff${config.lib.stylix.colors.base0B}";
        #    #"col.inactive" = "0xff${config.lib.stylix.colors.base02}";
        #  };
        #};

        decoration = {
          rounding = 10;
          rounding_power = 2;

          # blur = {
          #   enabled = true;
          #   size = 16;
          #   passes = 2;
          #   new_optimizations = true;
          # };

          #drop_shadow = true;
          #shadow_range = 4;
          #shadow_render_power = 3;
          #"col.shadow" = "rgba(1a1a1aee)";
        };

        misc = {
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
          enable_swallow = true;
          #render_ahead_of_time = false;
          disable_hyprland_logo = true;
        };

        animations = {
          enabled = true;

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          # bezier = "myBezier, 0.33, 0.82, 0.9, -0.08";

          animation = [
            "windows,     1, 7,  myBezier"
            "windowsOut,  1, 7,  default, popin 80%"
            "border,      1, 10, default"
            "borderangle, 1, 8,  default"
            "fade,        1, 7,  default"
            "workspaces,  1, 6,  default"
          ];
        };

        input = {
          kb_layout = "fr";
          kb_variant = "";
          #kb_options = "grp:caps_toggle";
	        kb_options = "";
	        numlock_by_default = true;
	        mouse_refocus = false;

          follow_mouse = 1;

          touchpad = {
            natural_scroll = "yes";
            middle_button_emulation = true;
	          clickfinger_behavior = false;
	          scroll_factor = 1.0;
          };

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        gestures = {
          #workspace_swipe = true;
          #workspace_swipe_fingers = 3;
          workspace_swipe_invert = true;
          workspace_swipe_distance = 200;
          workspace_swipe_forever = true;
        };
        gesture = [
          "3, horizontal, workspace"
          "3, up, mod: SUPER, fullscreen, maximize"
          "3, down, mod: SUPER, fullscreen, minimize"
        ];

        dwindle = {
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # Allow tooglesplit
        };

        bind = [
          "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

          "$mainMod CTRL, Q, exec, ${sessionCmd}"
          ", XF86PowerOff, exec, ${sessionCmd}"
          "$mainMod, L, exec, ${lockCmd}"

          "$mainMod, Return, exec, ${terminal}"
          "$mainMod, Q, killactive,"
          #"$mainMod, M, exit,"
	        "$mainMod CTRL, E, exec, emoji-script"
          "$mainMod, F, fullscreen, 0"
	        "$mainMod, M, fullscreen, 1"
	        "$mainMod, T, togglefloating,"
          "$mainMod CTRL, RETURN, exec, pkill wofi || wofi --show drun"
          "$mainMod, P, pseudo,"
          "$mainMod, J, togglesplit,"

          # Move focus with mainMod + arrow keys
          "$mainMod, left,  movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up,    movefocus, u"
          "$mainMod, down,  movefocus, d"

          # Moving windows
          "$mainMod SHIFT, left,  swapwindow, l"
          "$mainMod SHIFT, right, swapwindow, r"
          "$mainMod SHIFT, up,    swapwindow, u"
          "$mainMod SHIFT, down,  swapwindow, d"

          # Window resizing                     X  Y
          "$mainMod CTRL, left,  resizeactive, -60 0"
          "$mainMod CTRL, right, resizeactive,  60 0"
          "$mainMod CTRL, up,    resizeactive,  0 -60"
          "$mainMod CTRL, down,  resizeactive,  0  60"

          # Volume and Media Control
          ", XF86AudioRaiseVolume, exec, pamixer -i 5 "
          ", XF86AudioLowerVolume, exec, pamixer -d 5 "
          ", XF86AudioMute, exec, pamixer -t"
          ", XF86AudioMicMute, exec, pamixer --default-source -m"

          # Brightness control
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ", XF86MonBrightnessUp, exec, brightnessctl set +5%"

          #"SHIFT, XF86MonBrightnessDown, exec, ddcutil setvcp 10 $(($(brightnessctl get) * 100 / $(brightnessctl max)))"
          #"SHIFT, XF86MonBrightnessUp, exec, ddcutil setvcp 10 $(($(brightnessctl get) * 100 / $(brightnessctl max)))"
          "SHIFT, XF86MonBrightnessDown, exec, ddcutil setvcp 10 - 10"
          "SHIFT, XF86MonBrightnessUp, exec, ddcutil setvcp 10 + 10"
          "$mainMod SHIFT, F7, exec, ddcutil setvcp 10 100"


          # Screenshot
          '', Print, exec, grim -g "$(slurp)" - | swappy -f -''
          ''$mainMod SHIFT, S, exec, grim -g "$(slurp)" - | swappy -f -''

          # Waybar
          #"$mainMod, B, exec, pkill -SIGUSR1 waybar"
          #"$mainMod, W, exec, pkill -SIGUSR2 waybar"

	        # Power Button
	        #", XF86PowerOff, exit,"
	        "$mainMod SHIFT, Q, exit,"
        ]
        ++ lib.optionals (spawnBrowser != "") [
          "$mainMod, B, exec, ${spawnBrowser}"
	        "$mainMod, N, exec, ${spawnBrowserPrivate}"
        ]
        ++ lib.optionals (spawnEditor != "") [
          "$mainMod, E, exec, ${spawnEditor}"
        ];
        # ++ (
        #   # workspaces
        #   # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        #   builtins.concatLists (builtins.genList (i:
        #     let ws = i + 1;
        #     in [
        #       "$mainMod, code:1${toString i}, workspace, ${toString ws}"
        #       "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        #     ]
        #   )
        #     9)
        # );


        # Move/resize windows with mainMod + LMB/RMB and dragging
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        windowrule = [
          "float, title:^(Contrôle du volume)$"
	        "size 75% 75%, title:^(Contrôle du volume)$"

	        "float, title:^(Périphériques Bluetooth)$"
	        "size 75% 75%, title:^(Périphériques Bluetooth)$"

	        "float, title:^(Waypaper)$"
	        "size 50% 75%, title:^(Waypaper)$"
        ];

        windowrulev2 = [
	        "float, title:^(Picture-in-Picture)$"
	        "pin, title:^(Picture-in-Picture)$"
	        "move 69.5% 4%, title:^(Picture-in-Picture)$"
        ];

        xwayland = {
          force_zero_scaling = true;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
      };
      systemd.variables = ["--all"];
      xwayland = { enable = true; };
      systemd.enable = true;
    };

    home.packages = (with pkgs; [
      killall
      #polkit_gnome
      wl-clipboard
      hyprland-protocols
      hyprlock
      #hypridle
      hyprpaper

      # audio
      pamixer
      pavucontrol

      # screenshot
      grim
      slurp
      swappy

      bibata-cursors
      brightnessctl
    ]);
    services.hyprpolkitagent.enable = true;
    services.udiskie = {
      enable = true;
      tray = "auto";
      settings = {
        program_options = {
          appindicator = true;
        };
      };
    };
    services.hyprpaper = {
      enable = !useNoctalia;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;
        preload = [ "~/wallpaper/wallpaper.png" ];
        wallpaper = [ ",~/wallpaper/wallpaper.png" ];
      };
    };
    # services.hypridle = {
    #   enable = true;
    #   settings = {
    #     listener = [
    #       {
    #         timeout = 300;
    #         on-timeout = "hyprlock";
    #       }
    #     ];
    #   };
    # };
    userSettings.wofi.enable = true;
    userSettings.gtk.enable = true;
  };
}
