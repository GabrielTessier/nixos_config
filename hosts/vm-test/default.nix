{ config, lib, ... }:
{
  imports = [
    ./configuration.nix
    ./fileSystems.nix
  ];

  home-manager.users = builtins.listToAttrs
    (map (user : {
      name = user;
      value = ({
        config.userSettings.name = lib.mkForce user;
        imports = [
          (./users + "/${user}")
          (../../modules/user)
        ];
      });
    }) config.systemSettings.users);

  console.keyMap = lib.mkForce "fr";
}
