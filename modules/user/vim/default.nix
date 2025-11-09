{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.userSettings.vim;
in
{
  options = {
    userSettings.vim = {
      enable = lib.mkEnableOption "Enable vim";
    };
  };

  config = lib.mkIf cfg.enable {
	  programs.vim = {
		  enable = true;
    };
  };
}
