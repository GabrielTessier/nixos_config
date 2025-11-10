{ inputs, pkgs, pkgs-stable, config, lib, ... }:
let
  cfg = config.systemSettings.bluetooth;
in
{
  options = {
    systemSettings.bluetooth = {
      enable = lib.mkEnableOption "Enable bluetooth tools";
    };
  };

  config = lib.mkIf cfg.enable {
    services.blueman.enable = true;
  };
}
