{ config, lib, ... }:
let
  cfg = config.userSettings.thunderbird;
in {
  options = {
    userSettings.thunderbird = {
      enable = lib.mkEnableOption "Enable thunderbird";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        userChrome = ''
        #threadTree tr[data-properties~="unread"] div {
          background-color: #1c594c;
        }

        #threadTree tr[data-properties~="new"] {
          /*color: green !important;*/
        }
        '';
      };
    };
  };
}
