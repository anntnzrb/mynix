# home.nix --- Generic Home-Manager configuration for all hosts

{ config, lib, pkgs, user, inputs, ... }:

let
  userGitLab = "https://gitlab.com/anntnzrb";
  userSourceHut = "https://git.sr.ht/~anntnzrb";
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

    firefox = {
      enable     = true;
      package    = pkgs.firefox;
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
          id   = 0;
          bookmarks = {
            wikipedia.url = "https://en.wikipedia.org";
            archwiki.url  = "https://wiki.archlinux.org";
            youtube.url   = "https://youtube.com";

            # git
            github = {
              keyword = "ghub";
              url = "https://github.com";
            };
            gitlab = {
              keyword = "glab";
              url = "https://gitlab.com";
            };
            sourcehut = {
              keyword = "srchut";
              url = "https://git.sr.ht";
            };
          };
          settings = {
            "app.normandy.api_url" = "";
            "app.normandy.enabled" = false;
            "app.shield.optoutstudies.enabled" = false;
            "app.update.auto" = false;
            "beacon.enabled" = false;
            "breakpad.reportURL" = "";
            "browser.aboutConfig.showWarning" = false;
            "browser.cache.offline.enable" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "browser.crashReports.unsubmittedCheck.enabled" = false;
            "browser.disableResetPrompt" = true;
            "browser.fixup.alternate.enabled" = false;
            "browser.newtab.preload" = false;
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.newtabpage.enhanced" = false;
            "browser.newtabpage.introShown" = true;
            "browser.safebrowsing.appRepURL" = "";
            "browser.safebrowsing.blockedURIs.enabled" = false;
            "browser.safebrowsing.downloads.enabled" = false;
            "browser.safebrowsing.downloads.remote.enabled" = false;
            "browser.safebrowsing.downloads.remote.url" = "";
            "browser.safebrowsing.enabled" = false;
            "browser.safebrowsing.malware.enabled" = false;
            "browser.safebrowsing.phishing.enabled" = false;
            "browser.search.suggest.enabled" = false;
            "browser.selfsupport.url" = "";
            "browser.send_pings" = false;
            "browser.sessionstore.privacy_level" = 2;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.startup.homepage" = "https://ddg.gg";
            "browser.startup.homepage_override.mstone" = "ignore";
            "browser.tabs.crashReporting.sendReport" = false;
            "browser.urlbar.groupLabels.enabled" = false;
            "browser.urlbar.quicksuggest.enabled" = false;
            "browser.urlbar.speculativeConnect.enabled" = false;
            "browser.urlbar.trimURLs" = false;
            "datareporting.healthreport.service.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "device.sensors.ambientLight.enabled" = false;
            "device.sensors.enabled" = false;
            "device.sensors.motion.enabled" = false;
            "device.sensors.orientation.enabled" = false;
            "device.sensors.proximity.enabled" = false;
            "dom.battery.enabled" = false;
            "dom.event.clipboardevents.enabled" = false;
            "experiments.activeExperiment" = false;
            "experiments.enabled" = false;
            "experiments.manifest.uri" = "";
            "experiments.supported" = false;
            "extensions.getAddons.cache.enabled" = false;
            "extensions.getAddons.showPane" = false;
            "extensions.pocket.enabled" = false;
            "extensions.shield-recipe-client.api_url" = "";
            "extensions.shield-recipe-client.enabled" = false;
            "extensions.webservice.discoverURL" = "";
            "media.autoplay.default" = 1;
            "media.autoplay.enabled" = false;
            "media.navigator.enabled" = false;
            "media.peerconnection.enabled" = false;
            "media.video_stats.enabled" = false;
            "network.allow-experiments" = false;
            "network.captive-portal-service.enabled" = false;
            "network.cookie.cookieBehavior" = 1;
            "network.dns.disablePrefetch" = true;
            "network.dns.disablePrefetchFromHTTPS" = true;
            "network.http.speculative-parallel-limit" = 0;
            "network.predictor.enable-prefetch" = false;
            "network.predictor.enabled" = false;
            "network.prefetch-next" = false;
            "privacy.donottrackheader.enabled" = true;
            "privacy.donottrackheader.value" = 1;
            "privacy.trackingprotection.cryptomining.enabled" = true;
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.fingerprinting.enabled" = true;
            "privacy.trackingprotection.pbmode.enabled" = true;
            "privacy.usercontext.about_newtab_segregation.enabled" = true;
            "security.ssl.disable_session_identifiers" = true;
            "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false;
            "webgl.disabled" = true;
            "webgl.renderer-string-override" = " ";
            "webgl.vendor-string-override" = " ";
          };
        };
      };
    };

    chromium = {
      enable          = false;
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

    # LaTeX
    # minimal configuration for Emacs Org export via pandoc/xelatex
    (texlive.combine {
      inherit (texlive) scheme-small dvisvgm dvipng wrapfig amsmath ulem
        hyperref capt-of;
    })

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

    # my custom build of dwm
    (dwm.overrideAttrs (oldAttrs: rec {
      src = fetchgit {
        url    = "${userGitLab}/dwm";
        sha256 = "A4jWpLdFRuXuL4TlF8z4O5IVCm3shh7MVpQqnqyIr2A=";
      };
    }))

     # my custom build of dwmblocks
     (dwmblocks.overrideAttrs (oldAttrs: rec {
      src = fetchgit {
        url    = "${userGitLab}/dwmblocks";
        sha256 = "No9hx+V75+2VENRQLfRl0vWC/t89C9+RFfVr+9HFtks=";
      };
     }))

    # my custom build of st
    (st.overrideAttrs (oldAttrs: rec {
      src = fetchgit {
        url    = "${userGitLab}/st";
        sha256 = "YMcJCOgpna46ltAPqJJoqh5yA+ZgzU2I4jtpSj9Un2s=";
      };

      # dependencies
      buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
    }))

    # my custom build of dmenu
    (dmenu.overrideAttrs (oldAttrs: rec {
      src = fetchgit {
        url    = "${userGitLab}/dmenu";
        sha256 = "Hk3zwoBvXqxFP8IAd4Bcs10qgS8tH8rs0i3eUT3/u0o=";
      };
    }))
  ];
}
