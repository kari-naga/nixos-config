{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        padding: 0 5px;
      }
      window#waybar {
        background: #16191C;
        color: #AAB2BF;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 50;
        spacing = 5;
        margin-bottom = -11;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          # "mpd"
          "temperature"
          "network"
          "battery"
          "clock"
          "tray"
        ];
        "hyprland/workspaces" = {
          all-outputs = true;
        };
        network = {
          format-disconnected = "No Internet";
          format-ethernet = "Ethernet 󰈀 ";
          format-wifi = "{essid} {icon}";
          format-icons = [ "󰤯 " "󰤟 " "󰤢 " "󰤥 " "󰤨 " ];

        };
        battery = {
          format = "{capacity}% {icon}";
          tooltip-format = "{power} - {timeTo}";
          format-icons = [ " " " " " " " " " " ];
        };
        clock = {
          format = "{%I:%M %p}";
          format-alt = "{:%a, %b %d  %I:%M %p}";
        };
      };
    };
  };
}
