{
  description = "RazYang's Nix Flake Configurations";

  nixConfig = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
  };

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    flake-programs-sqlite.url = "github:wamserma/flake-programs-sqlite";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    impermanence.url = "github:nix-community/impermanence";
    treefmt-nix.url = "https://github.com/numtide/treefmt-nix/archive/refs/heads/main.zip";
    nixos-generators.url = "github:nix-community/nixos-generators";
    codex.url = "github:openai/codex/rust-v0.58.0";
    infuse.url = "git+https://codeberg.org/amjoseph/infuse.nix.git";
    infuse.flake = false;

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-programs-sqlite.inputs.nixpkgs.follows = "nixpkgs";
    flake-programs-sqlite.inputs.utils.follows = "flake-utils";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    #codex.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      treefmt-nix,
      flake-utils,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      nixpkgsConfig = {
        overlays = lib.attrValues (import ./overlays inputs);
        config.allowUnfree = true;
      };
      pkgsWithSystem = system: import nixpkgs (lib.mergeAttrs nixpkgsConfig { inherit system; });
      eachSystem = fun: flake-utils.lib.eachDefaultSystem (system: fun (pkgsWithSystem system));
    in
    eachSystem (pkgs: {
      packages = import ./packages { inherit inputs pkgs; };
      devShells = import ./dev-shells { inherit inputs pkgs; };
      formatter = (treefmt-nix.lib.evalModule pkgs (import ./treefmt.nix)).config.build.wrapper;
    })
    // {
      nixosModules = import ./nixos-modules;
      nixosConfigurations = import ./nixos-configurations { inherit inputs pkgsWithSystem; };
      homeModules = import ./home-modules;
      homeConfigurations = import ./home-configurations { inherit inputs pkgsWithSystem; };
    };
}
