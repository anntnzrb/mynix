# flake.nix --- NixOS flake configuration

{
  description = "The core of it all, careful.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      # home-manager pkgs sometimes get a little behind, follow nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra Emacs packages; i.e native-compilation binaries
    emacs-overlay.url = "github:nix-community/emacs-overlay";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      user = "annt";
    in {
      nixosConfigurations = (
        # hosts declared @ ./hosts/default.nix
        import ./nix/hosts {
          inherit (nixpkgs) lib;
          inherit self inputs user nixpkgs home-manager;
        }
      );
    };
}
