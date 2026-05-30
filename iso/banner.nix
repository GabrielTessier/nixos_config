# Builds the MOTD / getty banner shown on the live ISO. Differs by mode:
{
  lib,
  self,
}:
let
  greeting = "ISO built from rev: ${self.shortRev or self.dirtyShortRev or "dirty"}";

  bannerLines = [
    ""
    "============================================================"
    " nixos-minimal installer ISO"
    "============================================================"
    " Run the installer with:"
    ""
    "     install-host"
    ""
    ""
    greeting
    "============================================================"
    ""
  ];
in
lib.concatStringsSep "\n" bannerLines
