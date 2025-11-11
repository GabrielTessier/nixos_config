{ config, lib, pkgs, hostname, ... }:
let
  cfg = config.userSettings.wlogout;
  
  user = config.userSettings.name;
  wallpaper = ../../../hosts/${hostname}/users/${user}/wallpaper;
in
{
  options = {
    userSettings.wlogout = {
      enable = lib.mkEnableOption "Enable wlogout";
    };
  };

  config = lib.mkIf cfg.enable {
    # Utilisation de home-manager pour copier les icons
    home.file.".config/wlogout/icons" = {
      source = ./icons;
    };

    home.file.".config/wlogout/wallpaper" = {
      source = wallpaper;
    };
    
    programs.wlogout = {
      enable = true;
      layout = [
        {
          "label" = "suspend";
          "action" = "systemctl suspend";
          "text" = "Suspend";
          "keybind" = "u";
        }
        {
          "label" = "reboot";
          "action" = "systemctl reboot";
          "text" = "Restart";
          "keybind" = "r";
        }
        {
          "label" = "shutdown";
          "action" = "systemctl poweroff";
          "text" = "Power Off";
          "keybind" = "s";
        }
      ]
      ++ lib.optionals config.userSettings.hyprland.enable [
        {
          "label" = "logout";
          "action" = "${pkgs.hyprland}/bin/hyprctl dispatch exit";
          "text" = "Log Out";
          "keybind" = "e";
        }
        {
          "label" = "lock";
          "action" = "${pkgs.hyprlock}/bin/hyprlock";
          "text" = "Lock";
          "keybind" = "l";
        }
      ];
      style = ./style.css;
    };
  };
}
