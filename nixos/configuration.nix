{ inputs, lib, username, hostname, ...}: {
#  imports = [
#    ./hardware-configuration.nix
#    ./packages.nix
#    ./modules/bundle.nix
#  ];

#  disabledModules = [
#    ./modules/xserver.nix
#  ];

#  nixpkgs.overlays = [
    #inputs.polymc.overlay
#  ];

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = false;
    };
  };

  networking.hostName = hostname; # Define your hostname.

  time.timeZone = "Europe/Paris"; # Set your time zone.

  i18n.defaultLocale = "fr_FR.UTF-8"; # Select internationalisation properties.
  console.keyMap = lib.mkForce "fr";

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Enabling flakes

  system.stateVersion = "25.05"; # Don't change it bro
}
