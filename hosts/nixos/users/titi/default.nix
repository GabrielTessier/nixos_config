{ config, lib, pkgs, ... }:
{
  config = {
    userSettings = {
      fullname = "Titi";
      email = "";
    
      # setup
      shell = {
        enable = true;
      };

      # PROGRAMS
      editor = "vim"; # default editor
      git.enable = true;
    };
  };
}
