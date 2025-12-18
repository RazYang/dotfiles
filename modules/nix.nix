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
    settings = (import (inputs.self.outPath + "/flake.nix")).nixConfig);
    registry = inputs |> lib.mapAttrs (name: flake: { inherit flake; });
    nixPath = inputs |> lib.mapAttrs (name: flake: "${name}=${flake}") |> lib.attrValues;
  };

in
{
  config = {
    flake.modules.home.base =
      { pkgs, ... }:
      {
        nix = commonNixConfig // {
          package = lib.mkDefault (nixPackage pkgs);
          settings.auto-optimise-store = true;
          keepOldNixPath = false;
        };
        home.packages = [ (nixPackage pkgs) ];
      };
    flake.modules.nixos.base =
      { pkgs, ... }:
      {
        nix = commonNixConfig // {
          package = lib.mkForce (nixPackage pkgs);
          optimise.automatic = true;
        };
      };
    flake.modules.darwin.base =
      { pkgs, ... }:
      {
        nix = commonNixConfig // {
          package = lib.mkForce (nixPackage pkgs);
          optimise.automatic = true;
        };
      };
  };
}
