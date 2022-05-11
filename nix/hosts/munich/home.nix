# home.nix --- Concrete Home-Manager configuration :: Munich

{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      teams
      zoom-us

      # LaTeX/pandoc
      pandoc
      # full package needed for Emacs org-latex-export-to-pdf
      texlive.combined.scheme-full
    ];
  };
}
