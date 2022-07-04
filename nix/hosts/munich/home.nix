# home.nix --- Concrete Home-Manager configuration :: Munich

{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      libreoffice-still

      # streaming
      streamlink
      chatterino2

      # TODO: move
      nur.repos.foolnotion.cmake-init
    ];
  };
}
