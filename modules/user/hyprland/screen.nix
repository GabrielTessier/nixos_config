{ config, lib, ... }:
let
  defaultProfiles = {
    mirror = ''
      monitor=HDMI-A-1,preferred,auto,1
      monitor=eDP-1,preferred,auto,1,mirror,HDMI-A-1
    '';
    extended = ''
      monitor=eDP-1,preferred,auto,1
      monitor=HDMI-A-1,preferred,auto,1
    '';
  };
in
{
  options.userSettings.hyprland.screen.profiles = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = {};
    description = "Hyprland screen profiles, each key is a profile name, value is the monitor config";
  };

  config = {
    xdg.configFile = lib.mapAttrs' (name: text:
      lib.nameValuePair "hypr/profiles/${name}.conf" { inherit text; }
    ) (defaultProfiles // config.userSettings.hyprland.screen.profiles);

    home.activation.selectHyprScreenProfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    CONFIG_FOLDER="${config.xdg.configHome}/hypr"
    if [[ ! -f $CONFIG_FOLDER/screen_profile.conf ]]; then
        echo "source=$CONFIG_FOLDER/profiles/extended.conf" > $CONFIG_FOLDER/screen_profile.conf
    fi
    '';
  };
}
