{ config, lib, pkgs, ... }:
let
  cfg = config.userSettings.gpg;
in {
  options = {
    userSettings.gpg = {
      enable = lib.mkEnableOption "Enable gpg";
      signGit = {
        enable = lib.mkEnableOption "Sign git commit";
        signKey = lib.mkOption {
          default = "";
          description = "Key";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;
    programs.git.extraConfig.user.signingKey = lib.mkIf (cfg.signGit.enable) cfg.signGit.signKey;
    programs.git.extraConfig.commit.gpgsign = cfg.signGit.enable;
  };
}
