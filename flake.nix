{
  description = "My system configuration";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };
  };
  
  outputs = inputs@{ self, ... }:
    let
      nix-folder = "/etc/nixos/new_nix";
      system = "x86_64-linux";

      lib = inputs.nixpkgs.lib;
      hosts = builtins.filter (x: x != null) (lib.mapAttrsToList (name: value: if (value == "directory") then name else null) (builtins.readDir ./hosts));
    in {
      nixosConfigurations = builtins.listToAttrs
        (map (host: {
          name = host;
          value = inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              { config.networking.hostName = host; }
              (./hosts + "/${host}")
              ./modules/system
              
              inputs.nixos-facter-modules.nixosModules.facter
              { config.facter.reportPath = ./facter.json; }
              
              inputs.home-manager.nixosModules.home-manager {
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  inherit nix-folder;
                };
              }
              
              inputs.grub2-themes.nixosModules.default
            ];
            specialArgs = {
              inherit inputs;
              hostname = host;
            };
          };
        }) hosts);
    };
}
  
