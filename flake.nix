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
    
    #grub2-themes = {
    #  url = "github:vinceliuice/grub2-themes";
    #};
  };
  
  outputs = inputs@{ self, ... }:
  let
    # Change to suit your config
    hostname = "nixos";
    #usernames = [ "gabriel" ];
    nix-folder = "/etc/nixos/new_nix";
    
    system = "x86_64-linux";
  in {
    nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        { config.networking.hostName = hostname; }
        #{ config.systemSettings.users = usernames; }
        
        inputs.nixos-facter-modules.nixosModules.facter
        { config.facter.reportPath = ./facter.json; }
        
        inputs.home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = {
            inherit inputs;
            inherit nix-folder;
          };
        }
        ./nixos
        ./modules/system
        
        #inputs.grub2-themes.nixosModules.default
      ];
      specialArgs = {
        inherit inputs;
        inherit hostname;
      };
    };
  };
}
  
