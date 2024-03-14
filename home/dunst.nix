{ config, pkgs, lib, ... }:

{
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      size = "128x128";
      package = pkgs.gnome.adwaita-icon-theme;
    };
    settings = {
      global = {
        width = "(0, 300)";
        height = 200;
        origin = "bottom-right";
        offset = "20x20";
        scale = 0;
        notification_limit = 0;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        indicate_hidden = "yes";
        transparency = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 3;
        frame_color = "#11111b";
        gap_size = 5;
        separator_color = "frame";
        sort = "yes";
        # font = "Sofia Pro 16";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "end";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;
        enable_recursive_icon_lookup = true;
        always_run_scripts = true;
        sticky_history = "yes";
        history_length = 20;
        browser = "/run/current-system/sw/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 15;
        ignore_dbusclose = false;
        layer = "bottom";
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "context";
        mouse_right_click = "do_action";
      };
      experimental = {
        per_monitor_dpi = false;
      };
      urgency_low = {
        background = "#11111b";
        foreground = "#89b4fa";
        frame_color = "#89b4fa";
        timeout = 3;
      };
      urgency_normal = {
        background = "#11111b";
        foreground = "#a6e3a1";
        frame_color = "#a6e3a1";
        timeout = 3;
      };
      urgency_critical = {
        background = "#11111b";
        foreground = "#f38ba8";
        frame_color = "#f38ba8";
        timeout = 3;
      };
    };
  };
}
