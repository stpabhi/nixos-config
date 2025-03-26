{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = import ../../lib/overlays.nix;

  homebrew = {
    enable = true;
    casks  = [
      "istat-menus"
      "raycast"
    ];
  };

  users.users.abhi = {
    home = "/Users/abhi";
    shell = pkgs.zsh;
  };
}
