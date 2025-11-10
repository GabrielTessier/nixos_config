{ config, lib, pkgs, ... }:
let
  cfg = config.userSettings.wlogout;
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
    
    programs.wlogout = {
      enable = true;
      layout = [
        {
          "label" = "lock";
          "action" = "power-script lock";
          "text" = "Lock";
          "keybind" = "l";
        }
        {
          "label" = "logout";
          "action" = "power-script exit";
          "text" = "Log Out";
          "keybind" = "e";
        }
        {
          "label" = "suspend";
          "action" = "power-script suspend";
          "text" = "Suspend";
          "keybind" = "u";
        }
        {
          "label" = "reboot";
          "action" = "power-script reboot";
          "text" = "Restart";
          "keybind" = "r";
        }
        {
          "label" = "shutdown";
          "action" = "power-script shutdown";
          "text" = "Power Off";
          "keybind" = "s";
        }
      ];
      style = ./style.css;
    };
  };
}
