{ config, lib, pkgs, ... }:
let
  pdfviewer = config.userSettings.viewer.pdf;
in {
  options = {
    userSettings.viewer.pdf = {
      viewer = lib.mkOption {
        default = null;
        description = "Default pdf viewer";
        type = lib.types.enum [ "evince" "pdf4qt" null ];
      };
      spawn = lib.mkOption {
        default = "";
        description = "Command to spawn pdf viewer window (auto set)";
        type = lib.types.str;
      };
    };
  };

  config = {
    userSettings.viewer.pdf.spawn = lib.mkMerge [
      (lib.mkIf (pdfviewer.viewer == "evince") "evince")
      (lib.mkIf (pdfviewer.viewer == "pdf4qt") "Pdf4QtViewer")
      (lib.mkIf (pdfviewer.viewer == null) "")
    ];

    home.packages = (
      lib.optionals (pdfviewer.viewer == "evince") [ pkgs.evince ]
      ++ lib.optionals (pdfviewer.viewer == "pdf4qt") [ pkgs.pdf4qt ]
    );
  };
}
