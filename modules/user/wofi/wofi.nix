{ config, pkgs, lib, ... }:
let
  cfg = config.userSettings.wofi;
in
{
  options = {
    userSettings.wofi = {
      enable = lib.mkEnableOption "Enable wofi";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.wofi = {
      enable = true;
      settings = {
        prompt = "Search";
        allow_images = true;
        image_size = 50;
        width = "75%";
        height = "75%";
        show = "Search";
        term = "kitty";
        hide_scroll = true;
        print_command = true;
        insensitive = true;
        columns = 5;
        no_actions = true;
        matching = "contains";
      };
      style = ./style.css;
    };
  };
}
