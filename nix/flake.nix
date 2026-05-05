{
  description = "Home Manager configuration of kei-p";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nix-darwin, home-manager, ... }:
    let
      system = "aarch64-darwin";
    in
    {
      darwinConfigurations."default" = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kei-p = import ./home.nix;
          }
        ];
      };
    };
}
