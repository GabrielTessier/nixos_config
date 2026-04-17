{ lib, ... }:
{
  options = {
    userSettings.desktop.startupApps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Commands to run at startup";
    };
  };
}
