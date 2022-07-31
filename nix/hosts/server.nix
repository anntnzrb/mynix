# server.nix --- Server configurations for all hosts

{ user,
  ... }:

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
