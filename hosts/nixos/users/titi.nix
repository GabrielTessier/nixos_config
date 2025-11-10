{ config, lib, pkgs, ... }:
{
  config = {
    userSettings = {
      name = "Titi";
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
