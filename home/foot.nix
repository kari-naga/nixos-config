{ config, pkgs, lib, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Fira Code Nerd Font Ret";
        dpi-aware = "yes";
      };
    };
  };
}
