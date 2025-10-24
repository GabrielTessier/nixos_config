{ config, lib, pkgs, ... }:
let
  editor = config.userSettings.editor;
  term = config.userSettings.terminal;
in {
  options = {
    userSettings.editor = lib.mkOption {
      default = "emacs";
      description = "Default editor";
    };
    userSettings.spawnEditor = lib.mkOption {
      default = "";
      description = "Command to spawn editor";
    };
  };

  config = {
    #userSettings.emacs.enable = lib.mkIf (config.userSettings.editor == "emacs") true;
    userSettings.spawnEditor = lib.mkMerge [
      (lib.mkIf (editor == "emacs") "emacsclient -c -n -a 'emacs'")
      (lib.mkIf (builtins.elem editor [ "vim" "nvim" ]) ("exec " + term + " -e " + editor))
      (lib.mkIf (!(builtins.elem editor [ "emacs" "vim" "nvim" ])) editor)
    ];
    home.sessionVariables = {
      EDITOR =
        lib.mkMerge [
          (lib.mkIf (editor == "emacs") "emacsclient -c -n -a 'emacs'")
          (lib.mkIf (builtins.elem editor [ "vim" "nvim" ]) ("exec " + term + " -e " + editor))
          (lib.mkIf (!(builtins.elem editor [ "emacs" "vim" "nvim" ])) editor)
        ];
    };
  };
}
