{ config, lib, pkgs, ... }:

{
  imports = [ ./emails.nix ];
  config = {
    userSettings = {
      fullname = "Admin";
      email = "admin@example.com";

      # setup
      shell = {
        enable = true;
      };

      # PROGRAMS
      defaultBrowser = "firefox";
      editor = "emacs"; # default editor
      vim.enable = true; # other editor
      git.enable = true;
      discord.enable = true;
      thunderbird.enable = true;

      gpg = {
        enable = true;
        signGit = {
          enable = true;
          signKey = "<key> (`gpg --list-keys` after pub  ?????/0x<key>)";
        };
      };

      # wm
      hyprland.enable = true;
      wlogout.enable = true;
      waybar.enable = true;
    };
  };
}
