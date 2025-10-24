{ config, lib, pkgs, nix-folder, ... }:
let
  cfg = config.userSettings.git;
in {
  options = {
    userSettings.git = {
      enable = lib.mkEnableOption "Enable git";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.git
      pkgs.openssh
    ];
    programs.git = {
      enable = true;
      userName = config.userSettings.name;
      userEmail = config.userSettings.email;
      ignores = [
        "*~"
        ".swp"
      ];
      extraConfig = {
        init.defaultBranch = "master";
        safe.directory = [ nix-folder ];
        pull.rebase = false;
        core.editor = config.userSettings.editor;
      };
    };
    services.ssh-agent.enable = true;
  };
}
