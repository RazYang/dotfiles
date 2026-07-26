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
    registry = lib.mapAttrs (name: flake: { inherit flake; }) inputs;
    nixPath = lib.attrValues (lib.mapAttrs (name: flake: "${name}=${flake}") inputs);
  };

in
{
  config = {
    flake.modules.nixos.base = { pkgs, ... }: {
      nix = commonNixConfig // {
        package = lib.mkDefault pkgs.nixVersions.latest;
        optimise.automatic = true;
        channel.enable = false;
      };
    };
    flake.modules.darwin.base = { pkgs, ... }: {
      nix = commonNixConfig // {
        package = lib.mkDefault pkgs.nixVersions.latest;
        optimise.automatic = true;
      };
    };
  };
}
