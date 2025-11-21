{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.userSettings.discord;
in
{
  options = {
    userSettings.discord = {
      enable = lib.mkEnableOption "Enable emacs";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = (pkg:
      builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) [
        "discord"
      ]
    );
    home.packages = (with pkgs; [
      discord
    ]);
  };
}
