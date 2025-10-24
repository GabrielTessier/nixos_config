{ config, lib, pkgs, ... }:
let
  cfg = config.systemSettings.gpg;
in
{
  options = {
    systemSettings.gpg = {
      enable = lib.mkEnableOption "Enable gpg";
    };
  };
  
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pinentry-tty ];
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-tty;
    };
  };
}
