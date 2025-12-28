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
      builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) config.userSettings.allowUnfree
    );
  };
}
