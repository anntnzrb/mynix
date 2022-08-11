# shared.nix --- (Server + Desktop) configurations for all hosts

{ lib,
  pkgs,
  ... }:

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
        device             = "nodev"; # because of EFI
        version            = 2;
        efiSupport         = true;
        useOSProber        = true;    # for poli-booting
        configurationLimit = 10;
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
  # packages
  # ---------------------------------------------------------------------------
  # the following should be essential-only packages

  # non-free support for hardware-related stuff
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # essentials
    coreutils-full file
    curl wget
    git
    gnumake

    # utils
    atool p7zip rar unrar zip unzip
    direnv
    fzf
    htop
    tree

    # manuals
    man man-pages man-pages-posix

    # editors
    neovim
  ];

  # disable some graphical SSH password asker
  programs.ssh.enableAskPassword = false;

  # ---------------------------------------------------------------------------
  # services
  # ---------------------------------------------------------------------------

  services = {
    # SSH
    openssh.enable = true;
  };
}
