{ config, lib, pkgs, ...}:
let
  # Do not modify
  users = builtins.filter (x: x != null) (lib.mapAttrsToList (name: value:
    if (value == "directory") then
      name
    else
      null
  ) (builtins.readDir ./users));
in
{
  config = {
    # Set all system settings (can be modified)
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

    # Print list of users when rebuild (can be deleted)
    system.activationScripts.nixosBuildLog = {
      text = ''
        echo users : ${lib.concatStringsSep ", " users};
      '';
    };
  };
}
