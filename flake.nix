{
  description = "RazYang's Nix Flake Configurations";

  nixConfig = {
    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
  };

  inputs = {
    flake-utils.url = "https://github.com/numtide/flake-utils/archive/11707dc.zip";
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    nixpkgs-lib.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    home-manager.url = "https://github.com/nix-community/home-manager/archive/20561be.zip";
    nix-darwin.url = "https://github.com/nix-darwin/nix-darwin/archive/688427b.zip";
    nix-index-database.url = "https://github.com/nix-community/nix-index-database/archive/4194c58.zip";
    nixvim.url = "https://github.com/nix-community/nixvim/archive/a9d0e06.zip";
    impermanence.url = "https://github.com/nix-community/impermanence/archive/4b3e914.zip";
    treefmt-nix.url = "https://github.com/numtide/treefmt-nix/archive/5b4ee75.zip";
    nixos-generators.url = "https://github.com/nix-community/nixos-generators/archive/032a187.zip";
    flake-parts.url = "https://github.com/hercules-ci/flake-parts/archive/2cccadc.zip";
    infuse.url = "git+https://codeberg.org/amjoseph/infuse.nix.git";
    infuse.flake = false;
    systems.url = "path:./systems.nix";
    systems.flake = false;

    flake-utils.inputs.systems.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.systems.follows = "systems";
    nixvim.inputs.flake-parts.follows = "flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.inputs.nixlib.follows = "nixpkgs-lib";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      {
        inputs,
        lib,
        config,
        ...
      }:
      let
        flakeLib = (import ./lib { inherit lib; }).flake.lib;
        flakeModules = ./flake-modules |> flakeLib.importSubfolders;
      in
      {
        systems = import inputs.systems;
        imports = [
          inputs.home-manager.flakeModules.home-manager
          ./lib
          ./packages
          ./home
          ./nixos
          ./darwin
        ]
        ++ (flakeModules |> builtins.attrValues);
        flake.flakeModules = flakeModules;
      }
    );
}
