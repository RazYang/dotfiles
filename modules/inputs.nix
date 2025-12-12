{ inputs, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.default
  ];

  flake-file.outputs = ''
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } ./parts.nix
  '';

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
  };

}
