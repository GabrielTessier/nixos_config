{ config, lib, pkgs, ...}: {
  config = {
    systemSettings = {
      users = [ "gabriel" ];
      adminUsers = [ "gabriel" ];
      gpg.enable = true;
      hyprland.enable = true;
    };
    users.users.gabriel.description = "gabriel";
    home-manager.users.gabriel.userSettings = {
      name = "Gabriel TESSIER";
      email = "gabriel.tessier45@gmail.com";
    };
  };
}
