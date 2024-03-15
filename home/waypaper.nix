{ config, pkgs, lib, configHome, ... }:

{
  home.file."${configHome}/waypaper/config.ini" = {
    source = config.lib.file.mkOutOfStoreSymlink ./files/waypaper.ini;
  };
  home.file."${configHome}/waypaper/wallpapers" = {
    source = ./files/wallpapers;
  };
  # systemd.user.timers = {
  #   change-wallpaper = {
  #     Unit = {
  #       Description = "Change wallpaper periodically";
  #     };
  #     Timer = {
  #       OnBootSec = "20min";
  #       OnUnitActiveSec = "20min";
  #     };
  #     Install = {
  #       WantedBy = [ "timers.target" ];
  #     };
  #   };
  # };
  # systemd.user.services = {
  #   change-wallpaper = {
  #     Unit = {
  #       Description = "Change wallpaper periodically";
  #     };
  #     Service = {
  #       Type = "oneshot";
  #       ExecStart = "${pkgs.waypaper}/bin/waypaper --random";
  #       User = config._module.args.username;
  #     };
  #   };
  # };
}