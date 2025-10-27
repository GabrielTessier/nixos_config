{ inputs, pkgs, pkgs-stable, config, lib, ... }:

let
  cfg = config.systemSettings.c;
in
{
  options = {
    systemSettings.c = {
      enable = lib.mkEnableOption "Enable c tools";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      semgrep
      man-pages
      man-pages-posix
      gnumake
      cmake
      gcc
      rocmPackages.clang
      pkg-config
    ];
  };
}
