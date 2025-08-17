# Hyprland
{ pkgs, ... }: {
  specialisation.hyprland.configuration = {
    programs.hyprland = {
      enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
    
    # Initial login experience
    services.greetd = {
      enable = true;
      settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
    };
  };
}
