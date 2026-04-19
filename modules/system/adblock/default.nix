{ pkgs, config, lib, ... }:
let
  cfg = config.systemSettings.adblock;
  file = config.systemSettings.adblock.file;

  # Commit fixe du repo github
  rev = "14f265910f84091ff93495e1973e40f121ec8d63";
  fetch = name: sha256: pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/${rev}/hosts/${name}-compressed.txt";
    inherit sha256;
  };
  files = {
    light    = fetch "light"    "sha256-hJc6ouRxM5i48FGPEeZEpyeHJXcKR7aJrNrsRQOyv90=";
    normal   = fetch "multi"    "sha256-IQoCaTwL8HiKcirb7Dul9YHw3CWfej4d6phuo3sEu5Y=";
    pro      = fetch "pro"      "sha256-18v9/k05Z5VmO1C+Tt0MsMq4Qiu+fBSs9RPWzqDerXk=";
    pro-plus    = fetch "pro.plus" "sha256-fert6anu1oeTSVQyTnfXxDMGXOQVlxwVt6TLXNBNGZA=";
    ultimate = fetch "ultimate" "sha256-PDDgS8Ztx+PJXXC83izzzt+jrpVkYBpaziNKD68v8io=";
  };
in
{
  options = {
    systemSettings.adblock = {
      enable = lib.mkEnableOption "Enable adblock hosts";
      file = lib.mkOption {
        default = "pro";
        description = "File to use in https://github.com/hagezi/dns-blocklists";
        type = lib.types.enum [ "light" "normal" "pro" "pro-plus" "ultimate" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.extraHosts = builtins.readFile files.${file};
  };
}
