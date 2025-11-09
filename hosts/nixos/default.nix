{ config, lib, pkgs, hostname, ...}:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  home-manager.users = builtins.listToAttrs
    (map (user : {
      name = user;
      value = ({
        imports = [
          (./users + "/${user}.nix")
          ../../modules/user
        ];
      });
    }) config.systemSettings.users);
  
  console.keyMap = lib.mkForce "fr";
}
