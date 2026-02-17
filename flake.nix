{
  description = "Nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-master.url = "github:nixos/nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other packages
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs: let
    # Overlays is the list of overlays we want to apply from flake inputs.
    overlays = [
      (final: prev: {
        zigpkgs = inputs.zig.packages.${prev.stdenv.hostPlatform.system};
      })

      (final: prev: rec {
        # gh CLI on stable has bugs.
        gh = inputs.nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.gh;
      })
    ];

    mkSystem = import ./lib/mksystem.nix {
      inherit overlays nixpkgs inputs;
    };
  in {
    nixosConfigurations.homelab = mkSystem "homelab" {
      system = "x86_64-linux";
      user   = "abhi";
    };

    darwinConfigurations.mac-mini = mkSystem "mac-mini" {
      system = "aarch64-darwin";
      user   = "abhi";
      darwin = true;
    };
  };
}
