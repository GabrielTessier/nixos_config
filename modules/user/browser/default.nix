{ config, lib, pkgs, nix-folder, ... }:
let
  browser = config.userSettings.defaultBrowser;
in {
  options = {
    userSettings.defaultBrowser = lib.mkOption {
      default = null;
      description = "Default browser";
      type = lib.types.enum [ "firefox" null ];
    };
    userSettings.spawnBrowser = lib.mkOption {
      default = "";
      description = "Command to spawn a browser window";
      type = lib.types.str;
    };
    userSettings.spawnBrowserPrivate = lib.mkOption {
      default = "";
      description = "Command to spawn a private browser window";
      type = lib.types.str;
    };

  };

  config = {
    userSettings.firefox.enable = lib.mkIf (browser == "firefox") true;

    userSettings.spawnBrowser = lib.mkMerge [
      (lib.mkIf (browser == "firefox") "firefox")
      (lib.mkIf (browser == null) "")
    ];
    userSettings.spawnBrowserPrivate = lib.mkMerge [
      (lib.mkIf (browser == "firefox") "firefox --private-window")
      (lib.mkIf (browser == null) "")
    ];
  };
}
