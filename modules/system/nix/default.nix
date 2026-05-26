{ config, lib, pkgs, inputs, ... }:
{
  system.stateVersion = "25.11";
  environment.systemPackages = with pkgs; [
    nixd
  ];
}
