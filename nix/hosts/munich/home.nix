# home.nix --- Concrete Home-Manager configuration :: Munich

{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      libreoffice-still

      # streaming
      streamlink
      chatterino2
    ];
  };
}
