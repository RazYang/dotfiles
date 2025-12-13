{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.flake.modules.nix;
in
{

  config = {
    flake.modules.home.base =
      { pkgs, ... }:
      {
        nix = {
          package = pkgs.nixVersions.latest;
          keepOldNixPath = false;
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
          };
        };
      };
    # flake.modules.nixos.base =
    #   { pkgs, ... }:
    #   {
    #     nix = config.flake.modules.nix.settings;
    #   };
  };

}
