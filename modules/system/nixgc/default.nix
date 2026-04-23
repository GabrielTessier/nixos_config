{ config, lib, ... }:
let
  cfg = config.systemSettings.nixgc;
in
{
  options = {
    systemSettings.nixgc = {
      enable = lib.mkEnableOption "Enable nix-collect-garbage";
    };
  };

  config = lib.mkIf cfg.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";   # every Monday 00:00
      persistent = true;  # runs at next startup if the scheduled time was missed
      options = "--delete-older-than 30d";
    };
    nix.optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    systemd.timers.nix-optimise.timerConfig.Persistent = true;
  };
}
