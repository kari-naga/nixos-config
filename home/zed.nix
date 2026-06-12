{ config, pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "astro"
      "csharp"
      "docker-compose"
      "dockerfile"
      "elixir"
      "emmet"
      "ghostty"
      "git-firefly"
      "gotmpl"
      "graphql"
      "haskell"
      "html"
      "java"
      "julia"
      "kotlin"
      "latex"
      "log"
      "lua"
      "make"
      "nix"
      "ocaml"
      "proto"
      "rainbow-csv"
      "ruby"
      "scss"
      "sql"
      "svelte"
      "swift"
      "toml"
      "typst"
      "vue"
      "xml"
      "zig"
    ];
    userSettings = {
      theme = {
        mode = "system";
        dark = "Ayu Dark";
        light = "Ayu Light";
      };
      disable_ai = true;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      ui_font_size = 16;
      buffer_font_size = 15;
      cli_default_open_behavior = "new_window";
      buffer_font_family = "BerkeleyMono Nerd Font Mono";
    };
  };
}
