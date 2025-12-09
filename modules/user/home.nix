{ config, lib, pkgs, hostname, ... }:
let
  user = config.userSettings.name;
  wallpaper = ../../hosts/${hostname}/users/${user}/wallpaper;
in
{
  home.packages = (with pkgs; [
    bat
    fd
  ]);

  home.file."wallpaper".source = wallpaper;
}
