# default.nix --- Declaration of hosts

{ self, lib, inputs, nixpkgs, nur, home-manager, user, ... }:

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
      ./configuration.nix
      { nixpkgs.overlays = [ nur.overlay ]; }

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs   = true;
        home-manager.useUserPackages = true;
        # flake variables
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./munich/home.nix
          ];
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
      ./configuration.nix
      { nixpkgs.overlays = [ nur.overlay ]; }

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs   = true;
        home-manager.useUserPackages = true;
        # flake variables
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./solna/home.nix
          ];
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
      ./configuration.nix
      { nixpkgs.overlays = [ nur.overlay ]; }

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs   = true;
        home-manager.useUserPackages = true;
        # flake variables
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./zadar/home.nix
          ];
        };
      }
    ];
  };
}
