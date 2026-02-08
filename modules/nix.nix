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
      { pkgs, ... }:
      {
        nix = commonNixConfig // {
          package = lib.mkDefault pkgs.nix;
          settings.auto-optimise-store = true;
          keepOldNixPath = false;
          channels = lib.mkForce { };
        };
        home.packages = [ pkgs.nix ];
      };
    flake.modules.nixos.base =
      { pkgs, ... }:
      {
        nix = commonNixConfig // {
          package = lib.mkForce pkgs.nix;
          optimise.automatic = true;
          channel.enable = false;
        };
      };
    flake.modules.darwin.base =
      { pkgs, ... }:
      {
        nix = commonNixConfig // {
          package = lib.mkForce pkgs.nix;
          optimise.automatic = true;
        };
      };
  };
}
