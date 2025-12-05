{ config, lib, pkgs, ... }:
let
  cfg = config.systemSettings.openvpn;
in
{
  options = {
    systemSettings.openvpn = {
      enable = lib.mkEnableOption "Enable openvpn";
    };
  };

  config = lib.mkIf cfg.enable {
    services.openvpn.servers = {
      ensimag = { config = '' config /root/nixos/openvpn/ensimag.conf ''; };
    };
  };
}
