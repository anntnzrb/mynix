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
    xserver = {
      videoDrivers = [ "nvidia" ];

      # libinput
      libinput = {
        enable = true;
        touchpad.accelProfile = "flat";
      };
    };

    # TLP (power management for laptops)
    tlp.enable = true;
  };
}
