{ config, lib, pkgs, inputs, ... }:
let
  locale = config.i18n.defaultLocale;
in
{
  config = {
    # Packages
    environment.systemPackages = with pkgs; [
      git
      (import ./scripts/_emoji-script.nix { inherit pkgs; })
    ];

    # Journal
    services.journald = {
      extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
    };

    # Locale and TZ
    time.timeZone = "Europe/Paris";
    services.timesyncd.enable = lib.mkForce true;
    i18n.defaultLocale = "fr_FR.UTF-8";
    i18n.extraLocaleSettings = lib.genAttrs [
      "LC_ADDRESS" "LC_IDENTIFICATION" "LC_MEASUREMENT" "LC_MONETARY"
      "LC_NAME"    "LC_NUMERIC"        "LC_PAPER"       "LC_TELEPHONE"
      "LC_TIME"
    ] (_: locale);

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
      timeout = 2;
      grub = {
        efiSupport = true;
        enable = true;
        device = "nodev";
        splashImage = null;
        backgroundColor = null;
        theme = null;
      };
    };

    # Networking
    networking.useDHCP = false;              # disables the global dhcpcd
    networking.dhcpcd.enable = false;        # force-disable dhcpcd entirely
    networking.networkmanager.enable = true; # NetworkManager handles DHCP itself
    systemd.services.NetworkManager-wait-online.enable = false;

    # Remove bloat
    programs.nano.enable = lib.mkForce false;

    # Localsend is helpful for setting up new systems or quickly transferring files
    programs.localsend.enable = true;
    programs.localsend.openFirewall = true;
  };
}
