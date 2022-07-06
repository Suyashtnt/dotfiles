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
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, nh, flake-utils, ... }:
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
            { _module.args = { inherit overlays nh; }; }
            ./users/tntman/home.nix
          ];
        };
      };
      nixosConfigurations = {
        GAMER-PC = lib.nixosSystem {
          inherit system;

          modules = [
            ./system/GAMER-PC/configuration.nix
          ];
        };
      };
      devShell.${system} = pkgs.mkShell {
        buildInputs = with pkgs; [ rnix-lsp sumneko-lua-language-server stylua python311 ];
      };
    };
}
