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
    infuse = {
      url = "git+https://codeberg.org/amjoseph/infuse.nix.git";
      flake = false;
    };

    systems = {
      url = "path:./systems.nix";
      flake = false;
    };

    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    nixpkgs-lib.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    impermanence.url = "https://github.com/nix-community/impermanence/archive/4b3e914.zip";

    flake-utils = {
      url = "https://github.com/numtide/flake-utils/archive/11707dc.zip";
      inputs.systems.follows = "nixpkgs";
    };

    home-manager = {
      url = "https://github.com/nix-community/home-manager/archive/20561be.zip";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "https://github.com/nix-darwin/nix-darwin/archive/688427b.zip";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "https://github.com/nix-community/nix-index-database/archive/4194c58.zip";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nixvim = {
      url = "https://github.com/nix-community/nixvim/archive/a9d0e06.zip";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };
    treefmt-nix = {
      url = "https://github.com/numtide/treefmt-nix/archive/5b4ee75.zip";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "https://github.com/nix-community/nixos-generators/archive/032a187.zip";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixlib.follows = "nixpkgs-lib";
      };
    };

    flake-parts = {
      url = "https://github.com/hercules-ci/flake-parts/archive/2cccadc.zip";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };

    services-flake.url = "https://github.com/juspay/services-flake/archive/8b6244f.zip";
    process-compose-flake.url = "https://github.com/Platonic-Systems/process-compose-flake/archive/3667881.zip";

    devshell = {
      url = "https://github.com/numtide/devshell/archive/17ed8d9.zip";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake {
      inherit inputs;
      specialArgs = {
        systems = import inputs.systems;
        my-lib = import ./lib { lib = inputs.nixpkgs-lib.lib; };
        infuse = (import inputs.infuse { lib = inputs.nixpkgs-lib.lib; }).v1.infuse;
      };
    } ./flake-modules/top-level.nix;
}
