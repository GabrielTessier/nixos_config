{ config, inputs, lib, ... }:
let
  cfg = config.userSettings.caelestia;
in {
  options = {
    userSettings.caelestia = {
      enable = lib.mkEnableOption "Enable caelestia shell";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.caelestia-shell.packages."x86_64-linux".default
    ];
    home.file.".config/caelestia/shell.json".source = ./shell.json;
  };
}
