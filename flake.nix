{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = { self, nixpkgs, lanzaboote, home-manager, ... } @ attrs:
  let
    system = "x86_64-linux";
    hostname = "FusionBolt";
    username = "atom";
    persistent = "/persistent";
    args = { inherit hostname username persistent; };
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      specialArgs = attrs;
      modules = [
        ./configuration.nix
        lanzaboote.nixosModules.lanzaboote
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = import ./home.nix;
          };
        }
        { _module = { inherit args; }; }
      ];
    };
  };
}
