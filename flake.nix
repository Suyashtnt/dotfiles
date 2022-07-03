{
  description = "Suyashtnt's (maybe) good dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, nh, ... }:
    let
      system = "x86_64-linux";
      overlays = [
        neovim-nightly-overlay.overlay
      ];
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true; # for nvidia, gitkraken, discord, etc
        };
      };
      lib = nixpkgs.lib;
    in
    {
      homeConfigurations = {
        GAMER-PC = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            ./users/tntman/home.nix
            {
              nixpkgs.overlays = overlays;
              home.packages = [ nh.packages.${system}.default ];
            }
          ];
        };
      };
      nixosConfigurations = {
        GAMER-PC = lib.nixosSystem {
          inherit system;

          modules = [
            ./system/configuration.nix
          ];
        };
      };
    };
}
