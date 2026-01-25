{ config, lib, pkgs, ... }:
let
  cfg = config.userSettings.gtk;
in
{
  options = {
    userSettings.gtk = {
      enable = lib.mkEnableOption "Enable gtk";
    };
  };

  config = lib.mkIf cfg.enable {
    gtk = {
      enable = true;

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      font = {
        name = "Inter";
        size = 11;
      };

      cursorTheme = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };
    };
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
        icon-theme = "Papirus-Dark";
      };
    };
  };
}
