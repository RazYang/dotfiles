{
  outputs =
    inputs: (inputs.flake-parts.lib.evalFlakeModule { inherit inputs; } ./parts.nix).config.flake;

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    devshell = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://github.com/numtide/devshell/archive/17ed8d9.zip";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "https://github.com/hercules-ci/flake-parts/archive/2cccadc.zip";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://github.com/nix-community/home-manager/archive/20561be.zip";
    };
    impermanence.url = "https://github.com/nix-community/impermanence/archive/4b3e914.zip";
    infuse = {
      flake = false;
      url = "git+https://codeberg.org/amjoseph/infuse.nix.git";
    };
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://github.com/nix-darwin/nix-darwin/archive/688427b.zip";
    };
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://github.com/nix-community/nix-index-database/archive/4194c58.zip";
    };
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    nixpkgs-lib.follows = "nixpkgs";
    nixvim = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      url = "https://github.com/nix-community/nixvim/archive/a9d0e06.zip";
    };
    process-compose-flake.url = "https://github.com/Platonic-Systems/process-compose-flake/archive/3667881.zip";
    services-flake.url = "https://github.com/juspay/services-flake/archive/8b6244f.zip";
    systems.url = "https://github.com/nix-systems/default/archive/da67096.zip";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://github.com/numtide/treefmt-nix/archive/5b4ee75.zip";
    };
    import-tree.url = "https://github.com/vic/import-tree/archive/3c23749.zip";
    detsys-nix = {
      url = "https://github.com/DeterminateSystems/nix-src/archive/refs/tags/v3.14.0.zip";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    flake-compat = {
      url = "https://github.com/NixOS/flake-compat/archive/65f2313.zip";
      flake = false;
    };
  };

}
