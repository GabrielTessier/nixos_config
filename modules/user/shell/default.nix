{ config, lib, pkgs, nix-folder, ... }:
let
  cfg = config.userSettings.shell;
in {
  options = {
    userSettings.shell = {
      enable = lib.mkEnableOption "Enable fancy zsh with some necessary CLI utilities";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases =
        let
          flakeDir = nix-folder;
        in {
          rb = "sudo nixos-rebuild switch --flake ${flakeDir}";
          upd = "sudo nix flake update --flake ${flakeDir}";
          upg = "sudo nixos-rebuild switch --upgrade --flake ${flakeDir}";
          nixgc = "sudo nix-collect-garbage -d";
          optimise = "sudo nix-store --optimise";
          
          hms = "home-manager switch --flake ${flakeDir}";

          conf = "vim ${flakeDir}/nixos/configuration.nix";
          pkgs = "vim ${flakeDir}/nixos/packages.nix";

          ll = "ls -laF";
          se = "sudoedit";
          ff = "fastfetch";

          glog = "git log --all --oneline --decorate --graph";
        };

      history.size = 10000;
      history.path = "${config.xdg.dataHome}/zsh/history";

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
        theme = "agnoster"; # blinks is also really nice
      };

      #loginExtra = ''
    	#  [ "$(tty)" = "/dev/tty1" ] && exec Hyprland
      #'';
    };
  };
}
