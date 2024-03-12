{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    hyprland.url = "github:hyprwm/Hyprland";
  };
  outputs = { self, nixpkgs, lanzaboote, disko, home-manager, impermanence, ... } @ attrs:
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
        { _module = { inherit args; }; }
        lanzaboote.nixosModules.lanzaboote
        disko.nixosModules.disko
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            sharedModules = [
              "${impermanence}/home-manager.nix"
              { _module = { inherit args; }; }
            ];
            users.${username} = import ./home.nix;
          };
        }
        impermanence.nixosModules.impermanence
        ./disko-config.nix
        ./configuration.nix
      ];
    };
  };
}
