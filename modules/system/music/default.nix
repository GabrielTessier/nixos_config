{ config, pkgs, lib, ... }:
let
  cfg = config.systemSettings.music;
in {
  options = {
    systemSettings.music = {
      enable = lib.mkEnableOption "Enable music server";
    };
  };

  config = lib.mkIf cfg.enable {
    services.navidrome = {
      enable = true;
      #settings = {
      #  MusicFolder = "/var/lib/navidrome/music"; # default value
      #};
    };
  };
}
