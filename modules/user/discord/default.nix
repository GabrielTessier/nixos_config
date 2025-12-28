{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.userSettings.discord;
in
{
  options = {
    userSettings.discord = {
      enable = lib.mkEnableOption "Enable discord";
    };
  };

  config = lib.mkIf cfg.enable {
    userSettings.allowUnfree = [ "discord" ];
    home.packages = (with pkgs; [
      discord
    ]);
  };
}
