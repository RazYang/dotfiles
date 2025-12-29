{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.flake.modules.nix;
  commonNixConfig = {
    settings = (import (inputs.self.outPath + "/flake.nix")).nixConfig;
    registry = inputs |> lib.mapAttrs (name: flake: { inherit flake; });
    nixPath = inputs |> lib.mapAttrs (name: flake: "${name}=${flake}") |> lib.attrValues;
  };

in
{
  config = {
    flake.modules.home.base =
      { inputs', ... }:
      {
        nix = commonNixConfig // {
          package = lib.mkDefault inputs'.detsys-nix.packages.nix;
          settings.auto-optimise-store = true;
          keepOldNixPath = false;
        };
        home.packages = [ inputs'.detsys-nix.packages.nix ];
      };
    flake.modules.nixos.base =
      { inputs', ... }:
      {
        nix = commonNixConfig // {
          package = lib.mkForce inputs'.detsys-nix.packages.nix;
          optimise.automatic = true;
        };
      };
    flake.modules.darwin.base =
      { inputs', ... }:
      {
        nix = commonNixConfig // {
          package = lib.mkForce inputs'.detsys-nix.packages.nix;
          optimise.automatic = true;
        };
      };
  };
}
