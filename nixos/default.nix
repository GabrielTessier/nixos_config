{ config, lib, pkgs, hostname, ...}:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8*1024; # Use 2048MiB memory.
      cores = 4;
      #graphics = false;
    };
  };
  console.keyMap = lib.mkForce "fr";
}
