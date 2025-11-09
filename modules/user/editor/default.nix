{ config, lib, pkgs, ... }:
let
  editor = config.userSettings.editor;
  term = config.userSettings.terminal;
  spawnEditor = lib.mkMerge [
    (lib.mkIf (editor == "emacs") "emacsclient -c -n -a 'emacs'")
    (lib.mkIf (builtins.elem editor [ "vim" "nvim" ]) ("exec " + term + " -e " + editor))
    (lib.mkIf (!(builtins.elem editor [ "emacs" "vim" "nvim" ])) editor)
  ];
in {
  options = {
    userSettings.editor = lib.mkOption {
      default = "emacs";
      description = "Default editor";
      type = lib.types.enum [ "emacs" "vim" null ];
    };
    userSettings.spawnEditor = lib.mkOption {
      default = "";
      description = "Command to spawn editor";
    };
  };

  config = {
    userSettings.emacs.enable = lib.mkIf (editor == "emacs") true;
    userSettings.vim.enable = lib.mkIf (editor == "vim") true;
    
    userSettings.spawnEditor = spawnEditor;
    home.sessionVariables = {
      EDITOR = spawnEditor;
    };
  };
}
