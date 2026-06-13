{ ... }:

{
  programs.noctalia = {
    enable = true;

    systemd.enable = true;

    settings = {
      launch_apps_as_systemd_services = true;
      niri_overview_type_to_launch_enabled = true;
      # polkit_agent = true;
      setup_wizard_enabled = false;

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
        # default.path = "/path/to/wallpapers/wallpaper.png";
      };
    };
  };
}
