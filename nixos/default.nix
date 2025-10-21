{ config, lib, pkgs, hostname, ...}:
{
  imports = [
    ./configuration.nix
    #./hardware-configuration.nix
  ];

  #config = {
    
  #};

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = false;
    };
  };
  networking.hostName = hostname; # Define your hostname.
  console.keyMap = lib.mkForce "fr";
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enabling flakes
  system.stateVersion = "25.05"; # Don't change it bro
}
