{ pkgs, config, lib, ... }:
let
  cfg = config.systemSettings.adblock;
  blocklist = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/9a3c9dea3e4700300c8ddca5b091d0008bb619ab/hosts/pro-compressed.txt";
    sha256 = "sha256-bAWBvuD1gFQexJEm6X3pk3Kf0l/lfQJEFOVCjwljx8o=";
  };
in
{
  options = {
    systemSettings.adblock = {
      enable = lib.mkEnableOption "Enable adblock hosts";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.extraHosts = builtins.readFile blocklist;
  };
}
