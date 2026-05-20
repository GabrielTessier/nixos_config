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
        :root {
          --new-subject-color: lightgreen !important;
        }

        /* Remove annoying line on top of selected tab */
        #tabs-toolbar,
        #tabs-toolbar:hover {
          --tabline-color: none !important;
        }

        .new-messages > .container > .name {
          color: red !important;
        }

        #threadTree tr[data-properties~="unread"] div {
          background-color: #1c594c !important;
        }

        #threadTree tr[data-properties~="new"] div {
          background-color: #ac594c !important;
          color: var(--new-subject-color) !important;
        }
        '';
      };
    };
  };
}
