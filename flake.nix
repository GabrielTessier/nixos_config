{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    #home-manager = {
    #  url = "github:nix-community/home-manager/release-25.05";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #grub2-themes = {
    #  url = "github:vinceliuice/grub2-themes";
    #};

    #nixos-hardware = {
    #  url = "github:NixOS/nixos-hardware/master";
    #};
  };

  outputs = inputs@{ self, ... }:

    let
      # Change to suit your config
      hostname = "nixos";
      username = "gabriel";
      nix-folder = "/home/gabriel/new_nix";
      # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
      pc = "dell-inspiron-14-5420";

      system = "x86_64-linux";
    in {

      # nixos - system hostname
      nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos
          #inputs.grub2-themes.nixosModules.default
          #inputs.nixos-hardware.nixosModules.${pc}
        ];
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit hostname;
        };
      };
      
     # homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
     #   pkgs = inputs.nixpkgs.legacyPackages.${system};
     #   modules = [ ./home-manager/home.nix ];
     #   extraSpecialArgs = {
     #     inherit username;
     #     inherit nix-folder;
     #   };
     # };
    };
}
  
