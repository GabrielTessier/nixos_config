{ config, lib, pkgs, ... }:
{
  options = {
    userSettings = {
      allowUnfree = lib.mkOption {
        description = "List of unfree packages to allow";
        type = lib.types.listOf lib.types.str;
        default = [];
      };
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = (pkg:
      builtins.elem (lib.getName pkg) config.userSettings.allowUnfree
    );
  };
}
