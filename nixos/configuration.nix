{ config, lib, pkgs, ...}: {
  config = {
    systemSettings = {
      users = [ "gabriel" ];
      adminUsers = [ "gabriel" ];
    };
    users.users.gabriel.description = "gabriel";
    home-manager.users.gabriel.userSettings = {
      name = "gabriel";
      email = "EMAIL";
    };
  };
}
