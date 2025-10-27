{ inputs, pkgs, pkgs-stable, config, lib, ... }:

let
  cfg = config.systemSettings.waybar;
in
{
  options = {
    systemSettings.waybar = {
      enable = lib.mkEnableOption "Enable waybar";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      waybar
    ];
  };
}
