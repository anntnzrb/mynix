# server.nix --- Server configurations for all hosts

{ config, lib, pkgs, inputs, user, ... }:

{
  imports = [ ./shared.nix ];

  # ---------------------------------------------------------------------------
  # users
  # ---------------------------------------------------------------------------

  users.users.${user} = {
    isNormalUser    = true;
    initialPassword = "root";
    extraGroups     = [ "wheel" "networkmanager" ];
  };
}
