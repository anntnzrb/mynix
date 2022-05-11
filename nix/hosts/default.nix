# default.nix --- Declaration of hosts

{ self, lib, inputs, nixpkgs, home-manager, user, ... }:

let
  hostsFolder = "${self}/nix/hosts/";

  makeSystem = host: {
    # flake variables
    specialArgs = { inherit inputs user; };
    modules = [
      ./hostsFolder/host
      ./hostsFolder/configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs   = true;
        home-manager.useUserPackages = true;
        # flake variables
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [
            ./hostsFolder/home.nix
            ./hostsFolder/host/home.nix
          ];
        };
      }
    ];
  };

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
