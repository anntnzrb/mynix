# home.nix --- Concrete Home-Manager configuration :: Zadar

{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      teams
      zoom-us
    ];
  };
}
