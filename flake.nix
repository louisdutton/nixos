{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      home-manager,
      nixvim,
    }:
    let
      shared = rec {
        name = "louis";
        home = /home/${name};
        flake = /home/${name}/.config/nixos;
        displayName = "Louis Dutton";
        email = "louis.dutton@travelchapter.com";
      };
    in
    {
      nixosConfigurations."PF3X11W5" =
        let
          user = shared // {
            system = "x86_64-linux";
            hostName = "PF3X11W5";
          };
        in
        nixpkgs.lib.nixosSystem {
          system = user.system;
          specialArgs = {
            inherit user;
          };
          modules = [
            { nix.registry.nixpkgs.flake = nixpkgs; }
            ./configuration.nix
            ./vim
            ./wsl.nix
            ./java.nix
            ./cloudflare.nix
            nixos-wsl.nixosModules.wsl
            nixvim.nixosModules.nixvim
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user.name} = import ./home.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                inherit user;
              };
            }
          ];
        };
    };
}
