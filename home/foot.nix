{ config, pkgs, lib, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "Fira Code Nerd Font Ret";
        dpi-aware = "yes";
      };
      colors = {
        # alpha=1.0
        background = "1e1e2e";
        foreground = "cdd6f4";
        # flash=7f7f00
        # flash-alpha=0.5

        ## Normal/regular colors (color palette 0-7)
        regular0 = "45475a";  # black
        regular1 = "f38ba8";  # red
        regular2 = "a6e3a1";  # green
        regular3 = "f9e2af";  # yellow
        regular4 = "89b4fa";  # blue
        regular5 = "f5c2e7";  # magenta
        regular6 = "94e2d5";  # cyan
        regular7 = "bac2de";  # white

        ## Bright colors (color palette 8-15)
        bright0 = "585b70";   # bright black
        bright1 = "f38ba8";   # bright red
        bright2 = "a6e3a1";   # bright green
        bright3 = "f9e2af";   # bright yellow
        bright4 = "89b4fa";   # bright blue
        bright5 = "f5c2e7";   # bright magenta
        bright6 = "94e2d5";   # bright cyan
        bright7 = "a6adc8";   # bright white

        ## dimmed colors (see foot.ini(5) man page)
        # dim0=<not set>
        # ...
        # dim7=<not-set>

        ## The remaining 256-color palette
        # 16 = <256-color palette #16>
        # ...
        # 255 = <256-color palette #255>

        ## Misc colors
        selection-foreground = "D9E0EE"; # <inverse foreground/background>
        selection-background = "575268"; # <inverse foreground/background>
        # jump-labels=<regular0> <regular3>          # black-on-yellow
        # scrollback-indicator=<regular0> <bright4>  # black-on-bright-blue
        # search-box-no-match=<regular0> <regular1>  # black-on-red
        # search-box-match=<regular0> <regular3>     # black-on-yellow
        # urls=<regular3>
      };
    };
  };
}
