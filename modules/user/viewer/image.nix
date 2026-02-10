{ config, lib, pkgs, ... }:
let
  imageviewer = config.userSettings.viewer.image;
in {
  options = {
    userSettings.viewer.image = {
      viewer = lib.mkOption {
        default = null;
        description = "Default image viewer";
        type = lib.types.enum [ "eog" null ];
      };
      spawn = lib.mkOption {
        default = "";
        description = "Command to spawn image viewer window (auto set)";
        type = lib.types.str;
      };
    };
  };

  config = {
    userSettings.viewer.pdf.spawn = lib.mkMerge [
      (lib.mkIf (imageviewer.viewer == "eog") "eog")
      (lib.mkIf (imageviewer.viewer == null) "")
    ];

    home.packages = (
      lib.optionals (imageviewer.viewer == "eog") [ pkgs.eog ]
    );
  };
}
