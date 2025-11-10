{ config, lib, pkgs, ... }:

{
  options = {
    userSettings = {
      name = lib.mkOption {
        default = "";
        description = "User home name";
        type = lib.types.str;
      };
      fullname = lib.mkOption {
        default = "";
        description = "User full name";
        type = lib.types.str;
      };
      email = lib.mkOption {
        default = "";
        description = "User email";
        type = lib.types.str;
      };
    };
  };
}
