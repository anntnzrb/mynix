# configuration.nix --- Generic configuration.nix for all hosts

{ config, lib, pkgs, inputs, user, ... }:

{
  # ---------------------------------------------------------------------------
  # system
  # ---------------------------------------------------------------------------

  # careful with this
  system = {
    stateVersion = "22.05";
    autoUpgrade.enable = false;
  };

  virtualisation.docker.enable = true;

  # ---------------------------------------------------------------------------
  # Nix (the package manager)
  # ---------------------------------------------------------------------------

  nix = {
    settings = { auto-optimise-store = true; };

    # garbage-collector
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # enable flakes
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # ---------------------------------------------------------------------------
  # boot
  # ---------------------------------------------------------------------------

  boot = {
    cleanTmpDir = true;
    consoleLogLevel = 5;
    # bootloader
    loader = {
      efi.canTouchEfiVariables = true;

      # GRUB :: prefer over systemd-boot for poli-booting
      grub = {
        enable = true;
        configurationLimit = 10;
        device = "nodev"; # because of EFI
        efiSupport = true;
        useOSProber = true; # for poli-booting
        version = 2;

        # enable memory testing on GRUB (unfree program)
        memtest86.enable = true;
      };
    };
  };

  # ---------------------------------------------------------------------------
  # windowing system
  # ---------------------------------------------------------------------------
  # X11
  ## configuration should be set using home-manager, the following are very
  ## general rules, e.g: X11 not to launch automatically, disable DM, etc...

  services.xserver = {
    enable = true;
    autorun = false;
    displayManager.startx.enable = true;

    # libinput
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
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
    useDHCP = lib.mkDefault false;
    networkmanager.enable = true;
  };

  # ---------------------------------------------------------------------------
  # locale & time
  # ---------------------------------------------------------------------------

  # set your time zone
  time.timeZone = "America/Guayaquil";
  i18n.defaultLocale = "en_US.UTF-8";

  # ---------------------------------------------------------------------------
  # users
  # ---------------------------------------------------------------------------

  users.users.${user} = {
    isNormalUser = true;
    initialPassword = "root";
    extraGroups = [ "wheel" "networkmanager" "vboxusers" "docker" ];
    shell = pkgs.zsh;
  };

  # ---------------------------------------------------------------------------
  # packages
  # ---------------------------------------------------------------------------
  # the following should be essential-only packages

  # non-free support for hardware-related stuff
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # essentials
    coreutils-full
    file
    curl
    wget
    git
    gnumake

    # utils
    atool
    rar
    unrar
    unzip
    zip
    direnv
    fzf
    htop
    tree

    # manuals
    man
    man-pages
    man-pages-posix
    tldr

    # editors
    #vim
    # VIM9
    (vim.overrideAttrs (oldAttrs: rec {
      src = fetchgit {
        url    = "https://github.com/vim/vim";
	rev    = "083692d598139228e101b8c521aaef7bcf256e9a";
	sha256 = "1yb4tUeQaNt9+rvh6EuAzJ+otX3sg91HZYvqPc17th8=";
      };
    }))

    # misc
    woeusb # flash Windows iso
  ];

  # disable some graphical SSH password asker
  programs.ssh.enableAskPassword = false;

  # ---------------------------------------------------------------------------
  # fonts
  # ---------------------------------------------------------------------------

  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
    };
    fonts = with pkgs; [
      fantasque-sans-mono
      fira-code
      font-awesome
      inconsolata
      iosevka
      jetbrains-mono
      mononoki
      nerdfonts
      noto-fonts-emoji
      symbola
      times-newer-roman
    ];
  };

  # ---------------------------------------------------------------------------
  # services
  # ---------------------------------------------------------------------------

  services = {
    # SSH
    openssh.enable = true;

    # audio -- FIXME :: move to home-manager whenever available
    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
