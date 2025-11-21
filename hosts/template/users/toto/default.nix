{ config, lib, pkgs, ... }:

{
  config = {
    userSettings = {
      fullname = "toto";
      email = "toto@example.com";

      # setup
      shell = {
        enable = true;
      };

      # PROGRAMS
      defaultBrowser = "firefox";
      editor = "vim"; # default editor
      git.enable = true;

      # wm
      hyprland.enable = true;
      wlogout.enable = true;
      waybar.enable = true;
    };
  };
}
