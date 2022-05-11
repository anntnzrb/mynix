# configuration.nix --- Generic configuration.nix for all hosts

{ config, lib, pkgs, inputs, user, ... }:

{
  # ---------------------------------------------------------------------------
  # system
  # ---------------------------------------------------------------------------

  # careful with this
  system = {
    stateVersion       = "22.05";
    autoUpgrade.enable = false;
  };

  # ---------------------------------------------------------------------------
  # Nix (the package manager)
  # ---------------------------------------------------------------------------

  nix = {
    settings = {
      auto-optimise-store = true;
    };

    # garbage-collector
    gc = {
      automatic = true;
      dates     = "weekly";
      options   = "--delete-older-than 30d";
    };

    # enable flakes
    package      = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # ---------------------------------------------------------------------------
  # boot
  # ---------------------------------------------------------------------------

  boot = {
    cleanTmpDir     = true;
    consoleLogLevel = 5;
    # bootloader
    loader = {
      efi.canTouchEfiVariables = true;

      # GRUB :: prefer over systemd-boot for poli-booting
      grub = {
        enable             = true;
        configurationLimit = 10;
        device             = "nodev"; # because of EFI
        efiSupport         = true;
        useOSProber        = true;    # for poli-booting
        version            = 2;

        # enable memory testing on GRUB (unfree program)
        memtest86.enable = true;
      };
    };
  };

  # ---------------------------------------------------------------------------
  # console
  # ---------------------------------------------------------------------------

  console.font = "LatArCyrHeb-19";

  # ---------------------------------------------------------------------------
  # network
  # ---------------------------------------------------------------------------

  networking = {
    # useDHCP flag is deprecated, disable it
    useDHCP               = lib.mkDefault false;
    networkmanager.enable = true;
  };

  # ---------------------------------------------------------------------------
  # locale & time
  # ---------------------------------------------------------------------------

  # set your time zone
  time.timeZone      = "America/Guayaquil";
  i18n.defaultLocale = "en_US.UTF-8";

  # ---------------------------------------------------------------------------
  # windowing system
  # ---------------------------------------------------------------------------
  # X11
  ## configuration should be set using home-manager, the following are very
  ## general rules, e.g: X11 not to launch automatically, disable DM, etc...

  services.xserver = {
    enable                       = true;
    autorun                      = false;
    displayManager.startx.enable = true;

    # libinput
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
  };

  # ---------------------------------------------------------------------------
  # users
  # ---------------------------------------------------------------------------

  users.users.${user} = {
    isNormalUser    = true;
    initialPassword = "root";
    extraGroups     = [ "wheel" "networkmanager" ];
    shell           = pkgs.zsh;
  };

  # ---------------------------------------------------------------------------
  # packages
  # ---------------------------------------------------------------------------
  # the following should be essential-only packages

  # non-free support for hardware-related stuff
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    curl
    wget
    git
    gnumake

    # editors
    vim

    # utils
    atool
    file
    htop
    imagemagick
    rar
    tldr
    tree
    unrar
    unzip
    zip

    # manuals
    man
    man-pages
    man-pages-posix

    # core utilities
    coreutils-full
    bat
    exa
    ripgrep

    # audio
    pamixer
    pasystray
    pulsemixer

    # network
    networkmanagerapplet
  ];

  # disable some graphical SSH password asker
  programs.ssh.enableAskPassword = false;

  # ---------------------------------------------------------------------------
  # fonts
  # ---------------------------------------------------------------------------

  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      enable         = true;
      antialias      = true;
      hinting.enable = true;
    };
    fonts = with pkgs; [
      fantasque-sans-mono
      fira-code
      font-awesome
      inconsolata
      jetbrains-mono
      mononoki
      noto-fonts-emoji
      symbola
    ];
  };

  # ---------------------------------------------------------------------------
  # services
  # ---------------------------------------------------------------------------

  services = {
    # SSH
    openssh.enable = true;

    # audio
    pipewire = {
      enable       = true;
      audio.enable = true;
      alsa.enable  = true;
      pulse.enable = true;
    };
  };
}
