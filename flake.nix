{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      usernames = [ "gabriel" ];
      nix-folder = "/home/gabriel/new_nix";
      # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
      pc = "dell-inspiron-14-5420";

      system = "x86_64-linux";
    in {

      # nixos - system hostname
      nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { config.networking.hostName = hostname; }
          { config.systemSettings.users = usernames; }
          ./nixos
          ./modules/system
          #inputs.grub2-themes.nixosModules.default
          #inputs.nixos-hardware.nixosModules.${pc}
        ];
        specialArgs = {
          inherit inputs;
          inherit hostname;
        };
      };

      #homeConfigurations = builtins.listToAttrs
      #  (map (username: {
      #    name = username;
      #    value = inputs.lib.nixosSystem {
      #      inputs.home-manager.lib.homeManagerConfiguration = {
      #        pkgs = inputs.nixpkgs.legacyPackages.${system};
      #        modules = [
      #          ./modules/user
      #          ./nixos/home/${username}.nix
      #        ];
      #        extraSpecialArgs = {
      #          inherit username;
      #          inherit nix-folder;
      #        };
      #      };
      #    };
      #  }) usernames);
      homeConfigurations.gabriel = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          ./modules/user
          ./nixos/home/gabriel.nix
        ];
        extraSpecialArgs = {
          username = "gabriel";
          inherit nix-folder;
        };
      };
    };
}
  
