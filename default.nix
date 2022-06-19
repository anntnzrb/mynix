{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    git
    nixfmt
  ];

  shellHook = ''
   printf "=> nix-shell: set-up for dotfiles management\n"
  '';
}
