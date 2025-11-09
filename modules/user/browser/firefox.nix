{ config, lib, pkgs, nix-folder, ... }:
let
  cfg = config.userSettings.firefox;
in {
  options = {
    userSettings.firefox = {
      enable = lib.mkEnableOption "Enable firefox";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };
  };
}
