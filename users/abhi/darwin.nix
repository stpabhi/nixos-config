{ inputs, pkgs, ... }:

{
  homebrew = {
    enable = true;
    casks  = [
      "istat-menus"
    ];
    brews = [
      "gnupg"
      "starship"
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];

  users.users.abhi = {
    home = "/Users/abhi";
    shell = pkgs.zsh;
  };

  # Required for some settings like homebrew to know what user to apply to.
  system.primaryUser = "abhi";
}
