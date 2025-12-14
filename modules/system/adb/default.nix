{ pkgs, config, lib, ... }:
let
  cfg = config.systemSettings.adb;
in
{
  options = {
    systemSettings.adb = {
      enable = lib.mkEnableOption "Enable adb";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.adb.enable = true;
  };
}
