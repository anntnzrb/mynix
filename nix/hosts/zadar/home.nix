# home.nix --- Concrete Home-Manager configuration :: Zadar

{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      file # ex
    ];
  };
}
