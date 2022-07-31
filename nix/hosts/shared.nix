# shared.nix --- (Server + Desktop) configurations for all hosts

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
    vim

    # misc
    woeusb # flash Windows iso
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
