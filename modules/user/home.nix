{ config, lib, pkgs, hostname, ... }:
let
  user = config.userSettings.name;
in
{
  home.packages = (with pkgs; [
    bat
  ]);

  #home.file."wallpaper".source = ../../host/${hostname}/users/${user}/wallpaper;
}
