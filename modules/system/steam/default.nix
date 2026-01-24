{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.systemSettings.steam;
in
{
  options = {
    systemSettings.steam = {
      enable = lib.mkEnableOption "Enable steam";
    };
  };

  config = lib.mkIf cfg.enable {
    #userSettings.allowUnfree = [ "steam" "steam-unwrapped" ];
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
    ];

    programs.steam = {
      enable = true;
      # remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    # home.packages = (with pkgs; [
      # steam
    # ]);
    #boot.initrd.kernelModules = [ "amdgpu" ];
  };
}
