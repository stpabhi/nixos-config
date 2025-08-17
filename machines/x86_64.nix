{ config, pkgs, lib, currentSystem, currentSystemName, ... }:


{
  imports = [
    ../modules/specialization/hyprland.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';

    # public binary cache that I use for all my derivations. You can keep
    # this, use your own, or toss it. Its typically safe to use a binary cache
    # since the data inside is checksummed.
    settings = {
      substituters = ["https://mitchellh-nixos-config.cachix.org"];
      trusted-public-keys = ["mitchellh-nixos-config.cachix.org-1:bjEbXJyLrL1HZZHBbO4QALnI5faYZppzkU4D2s0G8RQ="];
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "dev";

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  networking.useDHCP = lib.mkDefault true;

  # Don't require password for sudo
  security.sudo.wheelNeedsPassword = false;

  # Manage fonts.
  fonts = {
    fontDir.enable = true;

    packages = [
      pkgs.fira-code
      pkgs.jetbrains-mono
    ];
  };

  environment.systemPackages = with pkgs; [
    cachix
    gnumake
    killall
  ];

  # Our default non-specialised desktop environment.
  services.xserver = lib.mkIf (config.specialisation != {}) {
    enable = true;
    xkb.layout = "us";
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;
  services.openssh.settings.PermitRootLogin = "no";

  services.resolved.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  networking = {
    networkmanager.enable = true;
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [22];

  system.stateVersion = "25.05";
}
