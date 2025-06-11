{
  description = "RazYang's Nix Flake Configurations";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
    treefmt-nix = {
      url = "https://github.com/numtide/treefmt-nix/archive/refs/heads/main.zip";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
      ];

      pkgsWithSystem =
        system:
        import inputs.nixpkgs {
          inherit system;
          overlays = inputs.nixpkgs.lib.attrValues inputs.self.overlays;
          config.allowUnfree = true;
        };

      eachSystem = f: inputs.nixpkgs.lib.genAttrs systems (system: f (pkgsWithSystem system));

      treefmtEval = eachSystem (
        pkgs:
        inputs.treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
          programs.statix.enable = true;
          programs.deadnix.enable = true;
          programs.deno.enable = true;
          programs.gofmt.enable = true;
          programs.rustfmt.enable = true;
          programs.clang-format.enable = true;
        }
      );
    in
    {
      overlays = import ./overlays { inherit inputs; };
      packages = eachSystem (pkgs: (import ./packages { inherit inputs pkgs; }));
      nixosModules = import ./nixos-modules;
      nixosConfigurations = import ./nixos-configurations { inherit inputs pkgsWithSystem; };

      homeModules = import ./home-modules;
      homeConfigurations = import ./home-configurations {
        inherit inputs pkgsWithSystem;
      };
      devShells = eachSystem (pkgs: (import ./dev-shells { inherit inputs pkgs; }));

      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
    };

}
