{ pkgs, inputs, ... }:

{

  users.users.abhi = {
    isNormalUser = true;
    home = "/home/abhi";
    extraGroups = [ "wheel" ];
  };
}
