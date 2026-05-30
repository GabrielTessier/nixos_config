{ ... }:
{
  config = {
    userSettings = {
      fullname = "Gabriel TESSIER";
      email = "gabriel.tessier45@gmail.com";

      # setup
      shell = {
        enable = true;
      #  apps.enable = true;
      #  extraApps.enable = true;
      };
      #xdg.enable = true;

      # PROGRAMS
      vim.enable = true; # other editor
      git.enable = true;
    };
  };
}
