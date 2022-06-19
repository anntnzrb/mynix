# home.nix --- Concrete Home-Manager configuration :: Solna

{ pkgs, ... }:

{
  home = {
    packages = with pkgs;
      [
        file # ex
      ];
  };
}
