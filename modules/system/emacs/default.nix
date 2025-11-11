{ inputs, pkgs, pkgs-stable, config, lib, ... }:

let
  cfg = config.systemSettings.emacs;
in
{
  options = {
    systemSettings.emacs = {
      enable = lib.mkEnableOption "Enable emacs";
    };
  };

  config = lib.mkIf cfg.enable {
    #services.emacs = {
    #  enable = true;
    #  install = true;
    #  startWithGraphical = true;
    #};
    environment.systemPackages = with pkgs; [
      emacs
      libvterm
      emacsPackages.vterm
    ];
  };
}
