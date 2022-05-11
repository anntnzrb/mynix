# default.nix --- Concrete NixOS configuration :: Solna

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ---------------------------------------------------------------------------
  # network
  # ---------------------------------------------------------------------------

  networking.hostName = "solna";

  # ---------------------------------------------------------------------------
  # services
  # ---------------------------------------------------------------------------

  services = {
    xserver = {
      videoDrivers = [ "intel" ];

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
