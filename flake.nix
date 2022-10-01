{
  description = "Suyashtnt's (maybe) good dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    crane.url = "github:ipetkov/crane";

    crane.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";

    flake-utils.url = "github:numtide/flake-utils";

    xresources.url = "github:catppuccin/xresources";
    xresources.flake = false;

    btop-theme.url = "github:catppuccin/btop";
    btop-theme.flake = false;

    fnlfmt-git.url = "sourcehut:~technomancy/fnlfmt";
    fnlfmt-git.flake = false;

    waybar-src = {
      url = "github:Alexays/Waybar";
      flake = false;
    };

    webcord.url = "github:fufexan/webcord-flake";

    geticons-source.url = "sourcehut:~zethra/geticons";
    geticons-source.flake = false;

    grub-theme.url = "github:catppuccin/grub";
    grub-theme.flake = false;

    catppuccin-discord.url = "github:catppuccin/discord";
    catppuccin-discord.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, nixpkgs-f2k, xresources, fnlfmt-git, grub-theme, catppuccin-discord, hyprland, nixpkgs-wayland, webcord, geticons-source, crane, hyprpaper, hyprpicker, waybar-src, btop-theme, ... }:
    let
      system = "x86_64-linux";
      overlays = [
        nixpkgs-f2k.overlays.default
        nixpkgs-wayland.overlay
      ];
      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true; # for nvidia, gitkraken, discord, etc
        };
      };
      discord-theme = catppuccin-discord + "/main.css";
      lib = nixpkgs.lib;

      craneLib = crane.lib.${system};
      commonArgs = {
        src = craneLib.cleanCargoSource geticons-source;
      };
      cargoArtifacts = craneLib.buildDepsOnly (commonArgs // {
        pname = "geticons-deps";
      });
      geticons = craneLib.buildPackage (commonArgs // {
        inherit cargoArtifacts;
      });
    in
    {
      nixosConfigurations = {
        GAMER-PC = lib.nixosSystem {
          inherit system;

          modules = [
            { _module.args = { inherit overlays grub-theme; }; }
            ./system/GAMER-PC/configuration.nix
            home-manager.nixosModules.home-manager
            # HM config configurer
            ({
              home-manager.useGlobalPkgs = true;
              home-manager.sharedModules = [
                hyprland.homeManagerModules.default
              ];
              home-manager.users.tntman = lib.mkMerge [
                { _module.args = { inherit overlays xresources pkgs lib discord-theme hyprland hyprpicker hyprpaper webcord geticons waybar-src btop-theme; }; }
                ./users/tntman/home.nix
              ];
            })
          ];
        };
      };
      devShell.${system} = pkgs.mkShell {
        packages = with pkgs; [
          rnix-lsp
          rustc
          cargo
          sumneko-lua-language-server
          stylua
          python311
          yaml-language-server
          fennel
          (fnlfmt.overrideAttrs (old: {
            version = "git";
            src = fnlfmt-git;
          }))
        ];
      };
    };
}
