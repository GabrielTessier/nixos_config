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
      adminUsers = [ "gabriel" ];
    };

    # Kernel d'usage général, pas de durcissement spécifique au matériel
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Pilotes virtio pour disques et réseau
    boot.initrd.kernelModules = [
      "virtio"
      "virtio_pci"
      "virtio_blk"
      "virtio_net"
    ];

    # Pas de microcode AMD/Intel nécessaire
    hardware.cpu.amd.updateMicrocode = false;
    hardware.cpu.intel.updateMicrocode = false;

    # Pas de firmware supplémentaire pour VM
    hardware.firmware = lib.mkForce [ ];

    # Support de base pour l'interface graphique QEMU
    services.xserver.videoDrivers = [
      "modesetting"
      "fbdev"
    ];

    # Optimisations VM
    services.qemuGuest.enable = true;

    system.activationScripts.nixosBuildLog = {
      text = ''
        echo users : ${lib.concatStringsSep ", " users};
      '';
    };   
  };
}
