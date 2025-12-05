{ inputs, pkgs, pkgs-stable, config, lib, ... }:

let
  cfg = config.systemSettings.hyprland;
in
{
  options = {
    systemSettings.hyprland = {
      enable = lib.mkEnableOption "Enable hyprland";
    };
  };

  config = lib.mkIf cfg.enable {
    # Power key should not shut off computer by defaultPower key shuts of
    services.logind.settings.Login.HandlePowerKey = "ignore";

    # Hyprland
    programs = {
      hyprland = {
        enable = true;
        #package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xwayland = {
          enable = true;
        };
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };
    };

    # Necessary packages
    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      udiskie
      jq
    ];

    services.udisks2.enable = true;

    services.upower.enable = true;

    # Keyring
    #security.pam.services.login.enableGnomeKeyring = true;
    #services.gnome.gnome-keyring.enable = true;

    # Dbus
    services.dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    programs.dconf.enable = true;

    # Pipewire
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Some fancy fonts
    fonts.packages = with pkgs; [
      # Fonts
      fira-sans
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      twemoji-color-font
      font-awesome
      powerline
      powerline-fonts
      powerline-symbols
      #(nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];
  };
}
