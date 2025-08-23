{ inputs, pkgs, ... }:

{
  homebrew = {
    enable = true;
    casks  = [
      "istat-menus"
    ];
    brews = [
      "gnupg"
    ];
  };

  users.users.abhi = {
    home = "/Users/abhi";
    shell = pkgs.zsh;
  };

  # Required for some settings like homebrew to know what user to apply to.
  system.primaryUser = "abhi";
}
