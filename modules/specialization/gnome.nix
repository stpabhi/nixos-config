# Gnome
{ pkgs, ... }: {
  specialisation.gnome.configuration = {
    services.xserver = {
      enable = true;
      xkb.layout = "us";
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };    
    #services.gnome.core-apps.enable = false;
    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];
  };
}
