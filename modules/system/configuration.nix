{ config, lib, pkgs, inputs, ... }:
{
  config = {
    # Packages
    environment.systemPackages = with pkgs; [
      git
      (import ./scripts/_emoji-script.nix { inherit pkgs; })
    ];

    # Journal
    services.journald.extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
    services.journald.rateLimitBurst = 500;
    services.journald.rateLimitInterval = "30s";

    # Locale and TZ
    time.timeZone = "Europe/Paris";
    services.timesyncd.enable = lib.mkForce true;
    i18n.defaultLocale = "fr_FR.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = config.i18n.defaultLocale;
      LC_IDENTIFICATION = config.i18n.defaultLocale;
      LC_MEASUREMENT = config.i18n.defaultLocale;
      LC_MONETARY = config.i18n.defaultLocale;
      LC_NAME = config.i18n.defaultLocale;
      LC_NUMERIC = config.i18n.defaultLocale;
      LC_PAPER = config.i18n.defaultLocale;
      LC_TELEPHONE = config.i18n.defaultLocale;
      LC_TIME = config.i18n.defaultLocale;
    };

    # Use zsh
    programs.zsh.enable = true;
    environment.shells = with pkgs; [ zsh ];
    users.defaultUserShell = pkgs.zsh;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # wheel group gets trusted access to nix daemon
    nix.settings.trusted-users = [ "@wheel" ];

    # Bootloader
    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        efiSupport = true;
        enable = true;
        device = "nodev";
      };
      grub2-theme = {
        enable = true;
        theme = "whitesur";
        footer = true;
      };
    };

    # Networking
    networking.networkmanager.enable = true; # Use networkmanager

    # Remove bloat
    programs.nano.enable = lib.mkForce false;

    # Localsend is helpful for setting up new systems or quickly transferring files
    programs.localsend.enable = true;
    programs.localsend.openFirewall = true;
  };
}
