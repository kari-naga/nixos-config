{ config, ... }:

{
  programs.noctalia = {
    enable = true;

    systemd.enable = true;

    settings = {
      shell = {
        launch_apps_as_systemd_services = true;
        niri_overview_type_to_launch_enabled = true;
        polkit_agent = true;
        setup_wizard_enabled = false;
        avatar_path = "${config.xdg.userDirs.pictures}/supernova-cropped.jpg";
        time_format = "{:%-I:%M %p}";
      };

      # This may also be a string or path to a .toml file.
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
        templates = {
          enable_builtin_templates = true;
          builtin_ids = [
            "gtk3"
            "gtk4"
            "kcolorscheme"
            "qt"
            "niri"
          ];
        };
      };

      wallpaper = {
        enabled = true;
        directory = "${config.xdg.userDirs.pictures}/Wallpapers";
        directory_light = "${config.xdg.userDirs.pictures}/Wallpapers";
        directory_dark = "${config.xdg.userDirs.pictures}/Wallpapers";
        default.path = "${config.xdg.userDirs.pictures}/Wallpapers/wallpaper.jpg";
      };

      backdrop.enabled = true;

      location.auto_locate = true;
      nightlight.enabled = true;

      bar.main = {
        auto_hide = true;
        reserve_space = false;
        layer = "overlay";
      };

      widget = {
        clock = {
          format = "{:%-I:%M %p}";
        };
        tray = {
          drawer = true;
        };
        network = {
          show_label = false;
        };
        brightness = {
          show_label = false;
        };
      };

      lockscreen_widgets = {
        enabled = true;
        widget = {
          clock = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 960.0;
            cy = 445.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "clock";
            settings = {
              background = false;
              format = "{:%-I:%M %p}";
            };
            weather = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 960.0;
              cy = 540.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "weather";
              settings = {
                background = false;
              };
            };
            login = {
              box_height = 0.0;
              box_width = 0.0;
              cx = 960.0;
              cy = 700.0;
              output = "eDP-1";
              rotation = 0.0;
              type = "login_box";
            };
          };
        };
      };
    };
  };
}
