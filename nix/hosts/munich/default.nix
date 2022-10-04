# default.nix --- Concrete NixOS configuration :: Munich

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ---------------------------------------------------------------------------
  # network
  # ---------------------------------------------------------------------------

  networking.hostName = "munich";

  virtualisation.virtualbox.host.enable = true;

  # ---------------------------------------------------------------------------
  # services
  # ---------------------------------------------------------------------------

  services.xserver.videoDrivers = [ "nvidia" ];
}
