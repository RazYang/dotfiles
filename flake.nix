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
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://install.determinate.systems"
      "https://nix-community.cachix.org"
      "https://nix-darwin.cachix.org"
      "https://cachix.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.determinate.systems:aHRYSxYP2rxdNsFfU5Wd0Q8d8Qqjrx4H8YB0uHK7P68="
      "nix-darwin.cachix.org-1:LxMyKzQk7Uqkc1Pfq5uhm9GSn07xkERpy+7cpwc006A="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
    ];
  };

  inputs = {
    devshell = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://github.com/numtide/devshell/archive/refs/heads/main.zip";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "https://github.com/hercules-ci/flake-parts/archive/refs/heads/main.zip";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://github.com/nix-community/home-manager/archive/refs/heads/release-25.11.zip";
    };
    impermanence.url = "https://github.com/nix-community/impermanence/archive/refs/heads/master.zip";
    infuse = {
      flake = false;
      url = "git+https://codeberg.org/amjoseph/infuse.nix.git";
    };
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://github.com/nix-darwin/nix-darwin/archive/refs/heads/nix-darwin-25.11.zip";
    };
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://github.com/nix-community/nix-index-database/archive/refs/heads/main.zip";
    };
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    nixpkgs-lib.follows = "nixpkgs";
    nixvim = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      url = "https://github.com/nix-community/nixvim/archive/refs/heads/nixos-25.11.zip";
    };
    systems.url = "https://github.com/nix-systems/default/archive/refs/heads/main.zip";
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://github.com/numtide/treefmt-nix/archive/refs/heads/main.zip";
    };
    import-tree.url = "https://github.com/vic/import-tree/archive/refs/tags/v0.1.0.zip";
    detsys-nix = {
      url = "https://github.com/DeterminateSystems/nix-src/archive/refs/tags/v3.15.1.zip";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    pwndbg = {
      url = "https://github.com/pwndbg/pwndbg/archive/refs/tags/2025.10.20.zip";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

}
