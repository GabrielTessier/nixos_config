{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.userSettings.steam;
in
{
  options = {
    userSettings.steam = {
      enable = lib.mkEnableOption "Enable steam";
    };
  };

  config = lib.mkIf cfg.enable {
    userSettings.allowUnfree = [ "steam" "steam-unwrapped" ];
    home.packages = (with pkgs; [
      steam
    ]);
  };
}
