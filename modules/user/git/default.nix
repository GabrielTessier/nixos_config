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
      pkgs.diff-so-fancy
    ];
    programs.git = {
      enable = true;
      userName = config.userSettings.fullname;
      userEmail = config.userSettings.email;
      ignores = [
        "*~"
        ".swp"
      ];
      aliases = {
        glog = "log --all --oneline --decorate --graph";
      };
      extraConfig = {
        init.defaultBranch = "master";
        safe.directory = [ nix-folder ];
        commit.verbose = true;
        core = {
          compression = 9;
          editor = config.userSettings.editor;
        };
        diff = {
          context = 5;
          renames = "copies";
        };
        log = {
          abbrevCommit = true;
          graphColors = "blue,yellow,cyan,magenta,green,red";
        };
        status = {
          branch = true;
          showStash = true;
        };
        pager = {
          branch = false;
          tag = false;
          diff = "diff-so-fancy | $PAGER";  # diff-so-fancy as diff pager
        };
        push = {
          default = "current";
          followTags = true;
        };
        pull = {
          rebase = false;
          default = "current";
        };
        submodule = {
          fetchJobs = 8;
        };
        blame = {
          coloring = "highlightRecent";
          date = "relative";
        };
        color = {
          "blame" = {
            highlightRecent = "black bold,1 year ago,white,1 month ago,default,7 days ago,blue";
          };
          "branch" = {
            current  = "magenta";
            local    = "default";
            remote   = "yellow";
            upstream = "green";
            plain    = "blue";
          };
          "diff" = {
            meta       = "white bold";
            frag       = "magenta";
            context    = "white";
            whitespace = "yellow reverse";
            old        = "red";
          };
        };
        diff-so-fancy = {
          markEmptyLines = false;
        };
        url = {
          "git@github.com:".insteadOf = "gh:";
        };
      };
    };
    services.ssh-agent.enable = true;
  };
}
