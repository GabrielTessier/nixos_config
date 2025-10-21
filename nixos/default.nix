{ config, lib, pkgs, hostname, ...}:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  home-manager.users = builtins.listToAttrs
    (map (user: {
            name = user;
            value = ({
              imports = [ ./home.nix ../modules/user ];
            });
          }) config.systemSettings.users);


  #virtualisation.vmVariant = {
  #  virtualisation = {
  #    memorySize = 2048; # Use 2048MiB memory.
  #    cores = 3;
      #graphics = false;
  #  };
  #};
  console.keyMap = lib.mkForce "fr";
}
