{ config, lib, pkgs, ... }:
let
  cfg = config.userSettings.spotify;
in
{
  options = {
    userSettings.spotify = {
      enable = lib.mkEnableOption "Enable spotify";
    };
  };

  config = lib.mkIf cfg.enable {
    userSettings.allowUnfree = [ "spotify" ];
    home.packages = (with pkgs; [
      spotify
    ]);
  };
}
