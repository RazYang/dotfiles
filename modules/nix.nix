{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.flake.modules.nix;
  nixPackage = pkgs: inputs.detsys-nix.packages.${pkgs.stdenv.hostPlatform.system}.nix;
  commonNixConfig = {
    nixPath = inputs |> lib.mapAttrs (name: flake: "${name}=${flake}") |> lib.attrValues;
    registry = inputs |> lib.mapAttrs (name: flake: { inherit flake; });
    settings = {
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
      auto-optimise-store = true;
    };
  };

in
{
  config = {
    flake.modules.home.base =
      { pkgs, ... }:
      {
        nix = commonNixConfig // {
          keepOldNixPath = false;
          package = lib.mkDefault (nixPackage pkgs);
        };
        home.packages = [ (nixPackage pkgs) ];
      };
    flake.modules.nixos.base =
      { pkgs, ... }:
      {
        nix = commonNixConfig // {
          package = lib.mkForce (nixPackage pkgs);
        };
      };
    flake.modules.darwin.base =
      { pkgs, ... }:
      {
        nix = commonNixConfig // { };
        package = lib.mkForce (nixPackage pkgs);
      };
  };
}
