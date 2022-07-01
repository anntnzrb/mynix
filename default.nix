{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    git
    nixfmt
  ];

  shellHook = ''
   printf "\n=> nix-shell: set-up for dotfiles management\n\n"
  '';
}
