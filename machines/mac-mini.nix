{ config, pkgs, ... }: {
  # Set in Sept 2024 as part of the macOS Sequoia release.
  system.stateVersion = 5;

  # This makes it work with the Determinate Nix installer
  ids.gids.nixbld = 30000;

  # We use proprietary software on this machine
  nixpkgs.config.allowUnfree = true;

  nix = {
    # We use the determinate-nix installer which manages Nix for us,
    # so we don't want nix-darwin to do it.
    enable = false;

    # We need to enable flakes
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

  # zsh is the default shell on Mac and we want to make sure that we're
  # configuring the rc correctly with nix-darwin paths.
  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
    '';


  environment.shells = with pkgs; [ bashInteractive zsh ];
  environment.systemPackages = with pkgs; [
    cachix
  ];
}
