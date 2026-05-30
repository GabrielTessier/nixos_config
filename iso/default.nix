
{ disko }:
{
  pkgs,
  lib,
  self,
  modulesPath,
  ...
}:
let
  diskoBin = disko.packages.${pkgs.stdenv.hostPlatform.system}.disko;
  banner = import ./banner.nix {
    inherit lib self;
  };

  installHostBin = pkgs.writeShellScriptBin "install-host" (
    builtins.replaceStrings [ "@diskoBin@" ] [ "${diskoBin}" ] (
      builtins.readFile ./install-host.sh
    )
  );

  repoTar = pkgs.runCommand "nixos-config.tar" {} ''
    tar -cf $out -C ${../.} .
  '';
in
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
  
  # FIXME: dynamic hostPlatform
  nixpkgs.hostPlatform = "x86_64-linux";

  nix = {
    nixPath = [ "nixpkgs=${pkgs.path}" ];
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  services = {
    qemuGuest.enable = true;
    openssh.settings.PermitRootLogin = "yes";
    getty.helpLine = lib.mkForce banner;
  };

  # Show IP addresses automatically on local TTY login
  environment.loginShellInit = ''
    if [ -z "$SSH_CONNECTION" ] && [ -t 1 ] && [ -z "$_IP_SHOWN" ]; then
      export _IP_SHOWN=1
      echo
      echo "Network addresses:"
      ${pkgs.iproute2}/bin/ip -brief address
      echo
    fi
  '';

  # Set a known password for the live user. We have to overwrite the default
  # first. The password is "nixos" (mkpasswd -m sha-512 "nixos")
  users.users."nixos".initialHashedPassword = lib.mkForce null;
  users.users.nixos.hashedPassword = lib.mkDefault "$6$FNQgExfQjsjOI/FY$13iDbTQON9OxLw2YMcA6sr4UBmPlcn/CgantPrwqXZk6mGGx.vW7TiJDjeeMBE0fx2oeBIpNM8PCSk4Bs0GqE0";

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce [
      "btrfs"
      "reiserfs"
      "vfat"
      "f2fs"
      "xfs"
      "ntfs"
      "cifs"
    ];
  };

  networking.hostName = "nixos-installer";

  console.keyMap = "fr";

  environment.systemPackages = with pkgs; [
    git
    efibootmgr
    gum
    fzf
    diskoBin
    installHostBin
  ];

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "nixos-installer";
        email = "nixos-installer@localhost";
      };
      safe.directory = [
        "/nixos-config"
        "/mnt/etc/nixos"
      ];
    };
  };

  isoImage.contents = [
    {
      source = repoTar;
      target = "/nixos-config.tar";
    }
  ];
  
  isoImage.squashfsCompression = "zstd -Xcompression-level 6";
}
