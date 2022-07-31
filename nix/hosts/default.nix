# default.nix --- Declaration of hosts

{ self,
  home-manager,
  inputs,
  lib,
  nixpkgs,
  nur,
  user,
  ... }:

let
  system = "x86_64-linux";

  lib = nixpkgs.lib;
in {

  # ---------------------------------------------------------------------------
  # Munich
  # ---------------------------------------------------------------------------

  munich = lib.nixosSystem {
    inherit system;
    # flake variables
    specialArgs = { inherit inputs user; };
    modules = [
      ./munich
      ./desktop.nix
      { nixpkgs.overlays = [ nur.overlay ]; }

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        # flake variables
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [ ./home.nix ./munich/home.nix ];
        };
      }
    ];
  };

  # ---------------------------------------------------------------------------
  # Solna
  # ---------------------------------------------------------------------------

  solna = lib.nixosSystem {
    inherit system;
    # flake variables
    specialArgs = { inherit inputs user; };
    modules = [
      ./solna
      ./desktop.nix
      { nixpkgs.overlays = [ nur.overlay ]; }

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        # flake variables
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [ ./home.nix ./solna/home.nix ];
        };
      }
    ];
  };

  # ---------------------------------------------------------------------------
  # Zadar
  # ---------------------------------------------------------------------------

  zadar = lib.nixosSystem {
    inherit system;
    # flake variables
    specialArgs = { inherit inputs user; };
    modules = [
      ./zadar
      ./server.nix
      { nixpkgs.overlays = [ nur.overlay ]; }

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        # flake variables
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [ ./zadar/home.nix ];
        };
      }
    ];
  };
}
