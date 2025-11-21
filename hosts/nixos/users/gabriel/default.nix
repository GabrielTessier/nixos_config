{ config, lib, pkgs, ... }:

{
  config = {
    userSettings = {
      fullname = "Gabriel TESSIER";
      email = "gabriel.tessier45@gmail.com";

      # setup
      shell = {
        enable = true;
      #  apps.enable = true;
      #  extraApps.enable = true;
      };
      #xdg.enable = true;

      # PROGRAMS
      defaultBrowser = "firefox";
      editor = "emacs"; # default editor
      vim.enable = true; # other editor
      #vscodium.enable = true;
      #yazi.enable = true;
      git.enable = true;
      #engineering.enable = false;
      #art.enable = false;
      #flatpak.enable = false;
      #godot.enable = false;
      #keepass.enable = false;
      #media.enable = true;
      #music.enable = false;
      #office.enable = true;
      #recording.enable = false;
      #virtualization = {
      #  virtualMachines.enable = false;
      #};
      #ai.enable = false;
      discord.enable = true;

      gpg = {
        enable = true;
        signGit = {
          enable = true;
          signKey = "51868780DE33CB95";
        };
      };

      # wm
      hyprland.enable = true;
      wlogout.enable = true;
      waybar.enable = true;

      # style
      #stylix.enable = true;

      # hardware
      #bluetooth.enable = true;
    };

    ## EXTRA CONFIG GOES HERE

  };
}
