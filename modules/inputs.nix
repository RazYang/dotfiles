{ inputs, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.default
  ];
  flake-file.outputs = ''
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ./parts.nix
  '';

  flake-file.nixConfig = {
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

  flake-file.inputs = {
    systems.url = "https://github.com/nix-systems/default/archive/da67096.zip";
    flake-parts = {
      url = "https://github.com/hercules-ci/flake-parts/archive/2cccadc.zip";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    flake-file.url = "https://github.com/vic/flake-file/archive/af92ed3.zip";

    infuse = {
      url = "git+https://codeberg.org/amjoseph/infuse.nix.git";
      flake = false;
    };

    impermanence.url = "https://github.com/nix-community/impermanence/archive/4b3e914.zip";
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
      inputs.nixpkgs.follows = "nixpkgs";
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

    devshell = {
      url = "https://github.com/numtide/devshell/archive/17ed8d9.zip";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    services-flake.url = "https://github.com/juspay/services-flake/archive/8b6244f.zip";
    process-compose-flake.url = "https://github.com/Platonic-Systems/process-compose-flake/archive/3667881.zip";
  };

}
