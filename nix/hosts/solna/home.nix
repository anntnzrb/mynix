# home.nix --- Concrete Home-Manager configuration :: Solna

{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      teams
      zoom-us
    ];
  };
}
