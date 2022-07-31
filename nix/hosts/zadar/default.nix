# default.nix --- Concrete NixOS configuration :: Zadar

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ---------------------------------------------------------------------------
  # network
  # ---------------------------------------------------------------------------

  networking.hostName = "zadar";

  # ---------------------------------------------------------------------------
  # services
  # ---------------------------------------------------------------------------

  services = {
    # TLP (power management for laptops)
    tlp.enable = true;
  };
}
