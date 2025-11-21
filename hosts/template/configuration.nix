{ config, lib, pkgs, ...}:
let
  users = builtins.filter (x: x != null) (lib.mapAttrsToList (name: value:
    if (value == "directory") then
      name
    else
      null
  ) (builtins.readDir ./users));
in
{
  config = {
    systemSettings = {
      users = users;
      adminUsers = [ "admin" ];
      gpg.enable = true;
      hyprland.enable = true;
      waybar.enable = true;
      c.enable = true;
      emacs.enable = true;
      bluetooth.enable = true;
      adblock.enable = true;
    };

    system.activationScripts.nixosBuildLog = {
      text = ''
        echo users : ${lib.concatStringsSep ", " users};
      '';
    };
  };
}
