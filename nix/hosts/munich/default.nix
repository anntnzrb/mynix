# default.nix --- Concrete NixOS configuration :: Munich

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # ---------------------------------------------------------------------------
  # network
  # ---------------------------------------------------------------------------

  networking.hostName = "munich";
}
