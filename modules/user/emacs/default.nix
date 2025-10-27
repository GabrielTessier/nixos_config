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
    home.file.".emacs.d/conf_file" = {
      source = ./conf_file;
    };
    
	  programs.emacs =
      {
		    enable = true;
		    extraConfig = ''(load-file (expand-file-name "conf_file/init.el" user-emacs-directory))'';
      };
  };
}
