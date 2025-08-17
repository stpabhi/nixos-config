{ config, pkgs, lib, ... }: {
  imports = [
    ./hardware/x86_64.nix
    ./hardware/nvidia.nix
    ./x86_64.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
