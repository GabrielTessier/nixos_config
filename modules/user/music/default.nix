{ config, pkgs, lib, ... }:
let
  cfg = config.userSettings.music;
in {
  options = {
    userSettings.music = {
      enable = lib.mkEnableOption "Enable music client";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.feishin
    ];
  };
}
