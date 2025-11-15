{ pkgs, config, lib, ... }:
let
  cfg = config.systemSettings.adblock;
  file = config.systemSettings.adblock.file;

  # Commit fixe du repo github
  rev = "9a3c9dea3e4700300c8ddca5b091d0008bb619ab";
  fetch = name: sha256: pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/${rev}/hosts/${name}-compressed.txt";
    inherit sha256;
  };
  files = {
    light    = fetch "light"    "sha256-+NtGt2Jf9JgKl2yILoNyXn7Ut98MGBTbm4N07PyR0a4=";
    normal   = fetch "multi"    "sha256-/X/EXKGis81Yz5UUY+RZjN1SjSIOEtQffZYnUmU4mU8=";
    pro      = fetch "pro"      "sha256-bAWBvuD1gFQexJEm6X3pk3Kf0l/lfQJEFOVCjwljx8o=";
    pro-plus    = fetch "pro.plus" "sha256-RyaqnJ/QDj7/s6uj5OSc0bCxe9sjvpmkNxoJbZATg+A=";
    ultimate = fetch "ultimate" "sha256-c7m4ka5QMPoVg1DQr8jVPgtApT/5Ne0mIx+8wDlF/SQ=";
  };
in
{
  options = {
    systemSettings.adblock = {
      enable = lib.mkEnableOption "Enable adblock hosts";
      file = lib.mkOption {
        default = "pro";
        description = "File to use in https://github.com/hagezi/dns-blocklists";
        type = lib.types.enum [ "light" "normal" "pro" "pro-plus" "ultimate" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.extraHosts = builtins.readFile files.${file};
  };
}
