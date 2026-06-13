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
        backdrop.enablde = true;
        directory = "${config.xdg.userDirs.pictures}/Wallpapers";
        directory_light = "${config.xdg.userDirs.pictures}/Wallpapers";
        directory_dark = "${config.xdg.userDirs.pictures}/Wallpapers";
        default.path = "${config.xdg.userDirs.pictures}/Wallpapers/wallpaper.jpg";
      };

      location.auto_locate = true;

      widget = {
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
    };
  };
}
