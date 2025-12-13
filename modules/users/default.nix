{ lib, ... }:
{
  imports = [
    ./yang.nix
    ./razyang.nix
    ./root.nix
  ];
  options.flake.modules.home = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
  };
}
