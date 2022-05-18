# home.nix --- Generic Home-Manager configuration for all hosts

{ config, lib, pkgs, user, inputs, ... }:

let
  userGitlab = "https://gitlab.com/anntnzrb";
in
{
  home = {
    username      = "${user}";
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
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  # ---------------------------------------------------------------------------
  # GTK
  # ---------------------------------------------------------------------------

  gtk = {
    enable    = true;
    iconTheme = {
      name    = "Kora";
      package = pkgs.kora-icon-theme;
    };
    theme = {
      name    = "Dracula";
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

    chromium = {
      enable          = true;
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
        "ponfpcnoihfmfllpaingbgckeeldkhle" # Enhancer for YouTube
        "mpbjkejclgfgadiemmefgebjfooflfhl" # CAPTCHA Solver

        # == Twitch
        "ajopnjidmegmdimjlfnijceegpefgped" # BetterTTV
        "fadndhdgpmmaapbmfcknlfgcflmmmieb" # FrankerFaceZ
      ];
    };
  };

  home.packages = with pkgs; [
    # apps
    alacritty
    feh
    firefox-esr    # non-chromium based backup browser
    joplin-desktop
    mpv
    pcmanfm
    zathura

    # misc
    redshift

    # utils
    bitwarden-cli
    chezmoi
    maim
    neofetch
    screenkey
    yt-dlp

    # editors
    emacsNativeComp

    # X11
    sxhkd
    picom
    unclutter
    xclip
    xdotool
    xorg.xbacklight

    # tools
    aspell
    aspellDicts.en
    aspellDicts.es
    aspellDicts.de

    # other
    dconf # GTK-themes

    # audio
    pamixer
    pasystray
    pulsemixer

    # network
    networkmanagerapplet

    # -------------------------------------------------------------------------
    # overrides & overlays
    # -------------------------------------------------------------------------

    # my custom build of st
    (st.overrideAttrs (oldAttrs: rec {
      src = builtins.fetchTarball {
        url    = "${userGitlab}/st/-/archive/master/st-master.tar.gz";
        sha256 = "0swzahzlls9vwa44vkb0wq1p47mad29ah3yhjqxax799x040kiv0";
      };

      # dependencies
      buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
    }))

    # my custom build of dmenu
    (dmenu.overrideAttrs (oldAttrs: rec {
      src = builtins.fetchTarball {
        url    = "${userGitlab}/dmenu/-/archive/main/dmenu-main.tar.gz";
        sha256 = "0jmvzwym3pidsbncl7rd5y0jlpdkbj07f0627x2sqpkgh31g6k8y";
      };
    }))
  ];
}
