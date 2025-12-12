{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.userSettings.emacs;
in
{
  options = {
    userSettings.emacs = {
      enable = lib.mkEnableOption "Enable emacs";
    };
  };

  config = lib.mkIf cfg.enable {
    # Utilisation de home-manager pour copier les fichiers configurations
    home.file.".emacs.d/old_config" = {
      source = ./conf_file;
    };

    home.file.".emacs.d/my_init.el" = {
      source = ./configuration/my_init.el;
    };

    home.file.".emacs.d/configuration.org" = {
      source = ./configuration/configuration.org;
    };
    home.file.".emacs.d/resources".source = ./configuration/resources;
    home.file.".emacs.d/themes".source = ./configuration/themes;

    programs.emacs = {
      enable = true;
      extraConfig = ''(load-file (expand-file-name "my_init.el" user-emacs-directory))'';
    };

    home.packages = (with pkgs; [
      mermaid-cli
    ]);
  };
}
