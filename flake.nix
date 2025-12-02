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
    ];
  };

  inputs = {
    flake-utils.url = "https://gh-proxy.org/https://github.com/numtide/flake-utils/archive/refs/heads/main.zip";
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    home-manager.url = "https://gh-proxy.org/https://github.com/nix-community/home-manager/archive/refs/heads/release-25.11.zip";
    nix-darwin.url = "https://gh-proxy.org/https://github.com/nix-darwin/nix-darwin/archive/refs/heads/nix-darwin-25.11.zip";
    flake-programs-sqlite.url = "https://gh-proxy.org/https://github.com/wamserma/flake-programs-sqlite/archive/refs/heads/main.zip";
    nix-index-database.url = "https://gh-proxy.org/https://github.com/nix-community/nix-index-database/archive/refs/heads/main.zip";
    nixvim.url = "https://gh-proxy.org/https://github.com/nix-community/nixvim/archive/refs/heads/nixos-25.11.zip";
    impermanence.url = "https://gh-proxy.org/https://github.com/nix-community/impermanence/archive/refs/heads/master.zip";
    treefmt-nix.url = "https://gh-proxy.org/https://github.com/numtide/treefmt-nix/archive/refs/heads/main.zip";
    nixos-generators.url = "https://gh-proxy.org/https://github.com/nix-community/nixos-generators/archive/refs/heads/master.zip";
    infuse.url = "git+https://codeberg.org/amjoseph/infuse.nix.git";
    infuse.flake = false;

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-programs-sqlite.inputs.nixpkgs.follows = "nixpkgs";
    flake-programs-sqlite.inputs.utils.follows = "flake-utils";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
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
      darwinModules = import ./darwin-modules;
      darwinConfigurations = import ./darwin-configurations { inherit inputs; };
      homeModules = import ./home-modules;
      homeConfigurations = import ./home-configurations { inherit inputs pkgsWithSystem; };
    };
}
