{ lib, ... }:
{
  options.flake.modules.home = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
  };
}
