# home.nix --- Generic Home-Manager configuration for all hosts

{ config, lib, pkgs, user, inputs, ... }:

let
  userGitLab = "https://gitlab.com/anntnzrb";
  userSourceHut = "https://git.sr.ht/~anntnzrb";
in {
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    # this is unrelated to NixOS itself (don't touch)
    stateVersion = "22.05";
  };

  # ---------------------------------------------------------------------------
  # windowing system
  # ---------------------------------------------------------------------------
  # X11

  xsession.windowManager.awesome.enable = true;

  # ---------------------------------------------------------------------------
  # overlays
  # ---------------------------------------------------------------------------

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];

  # ---------------------------------------------------------------------------
  # GTK
  # ---------------------------------------------------------------------------

  gtk = {
    enable = true;
    iconTheme = {
      name = "Kora";
      package = pkgs.kora-icon-theme;
    };
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };

  # ---------------------------------------------------------------------------
  # packages
  # ---------------------------------------------------------------------------

  programs = {
    home-manager.enable = true; # home-manager will handle itself

    # -------------------------------------------------------------------------
    # apps
    # -------------------------------------------------------------------------

    firefox = {
      enable = true;
      package = pkgs.firefox;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        # tools
        bitwarden
        buster-captcha-solver
        clearurls
        darkreader
        https-everywhere
        ublock-origin
        vimium

        # twitch
        betterttv
      ];
      profiles = {
        default = {
          name = "default";
          id = 0;
          bookmarks = {
            wikipedia.url = "https://en.wikipedia.org";

            # misc
            archwiki = {
              url = "https://wiki.archlinux.org";
              keyword = "aw";
            };

            youtube = {
              url = "https://youtube.com";
              keyword = "yt";
            };

            # git
            github = {
              url = "https://github.com";
              keyword = "ghub";
            };
            gitlab = {
              url = "https://gitlab.com";
              keyword = "glab";
            };
            sourcehut = {
              url = "https://git.sr.ht";
              keyword = "srht";
            };
          };
        };
      };
    };

    chromium = {
      enable = true;
      commandLineArgs = [
        "--disable-gpu" # sometimes causes flickering issues
      ];
      extensions = [
        # == tools
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "hfjbmagddngcpeloejdejnfgbamkjaeg" # Vimium C
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Mode Reader
        "cnojnbdhbhnkbcieeekonklommdnndci" # Reverse Image Search
        "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere
        "lckanjgmijmafbedllaakclkaicjfmnk" # ClearURLs
        "mnjggcdmjocbbbhaepdhchncahnbgone" # YouTube SponsorBlock
        "mpbjkejclgfgadiemmefgebjfooflfhl" # CAPTCHA Solver

        # == Twitch
        "ajopnjidmegmdimjlfnijceegpefgped" # BetterTTV
        "fadndhdgpmmaapbmfcknlfgcflmmmieb" # FrankerFaceZ
      ];
    };
  };

  home.packages = with pkgs; [
    # audio
    pamixer
    pasystray
    pulsemixer

    # network
    networkmanagerapplet

    # X11
    bspwm
    picom
    pywal
    sxhkd
    xbanish
    xclip
    xdotool
    xorg.xbacklight

    # apps
    alacritty
    bitwarden-cli
    feh
    joplin-desktop
    mpv
    pcmanfm
    redshift
    yt-dlp
    zathura

    # editors
    emacsNativeComp

    # tools
    aspell
    aspellDicts.de
    aspellDicts.en
    aspellDicts.es
    bat
    exa
    fd
    ripgrep # rust-coreutils
    dconf # GTK-themes
    imagemagick
    maim
    neofetch
    screenkey

    # LaTeX
    # minimal configuration for Emacs Org export via pandoc/xelatex
    (texlive.combine {
      inherit (texlive)
        scheme-small dvisvgm dvipng wrapfig amsmath ulem hyperref capt-of;
    })

    # -------------------------------------------------------------------------
    # overrides / overlays / manual stuff
    # -------------------------------------------------------------------------

    # my custom build of dwm
    (dwm.overrideAttrs (oldAttrs: rec {
      src = fetchgit {
        url = "${userGitLab}/dwm";
        sha256 = "P9bQEp+jwAluwoiYbgtP9mpRIthfdxL3PylWRdhWe5Y=";
      };
    }))

    # my custom build of dwmblocks
    (dwmblocks.overrideAttrs (oldAttrs: rec {
      src = fetchgit {
        url = "${userGitLab}/dwmblocks";
        sha256 = "B2eDTe09GOIh1ZjAXz6vPt9BH74ZJV08J4zyy7GcuAE=";
      };
    }))

    # my custom build of st
    (st.overrideAttrs (oldAttrs: rec {
      src = fetchgit {
        url = "${userGitLab}/st";
        sha256 = "YMcJCOgpna46ltAPqJJoqh5yA+ZgzU2I4jtpSj9Un2s=";
      };

      # dependencies
      buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
    }))

    # my custom build of dmenu
    (dmenu.overrideAttrs (oldAttrs: rec {
      src = fetchgit {
        url = "${userGitLab}/dmenu";
        sha256 = "Hk3zwoBvXqxFP8IAd4Bcs10qgS8tH8rs0i3eUT3/u0o=";
      };
    }))
  ];
}
