{
  lib,
  inputs,
  config,
  withSystem,
  ...
}:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  options.flake.modules = {
    users = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule {
          options = {
            system = lib.mkOption { type = lib.types.enum (import inputs.systems); };
            modules = lib.mkOption { type = lib.types.listOf lib.types.deferredModule; };
          };
        }
      );
    };
    home = lib.mkOption { type = lib.types.lazyAttrsOf lib.types.deferredModule; };
  };

  config = {
    flake.homeConfigurations = lib.flip lib.mapAttrs config.flake.modules.users (
      _: value:
      withSystem value.system (
        { pkgs, ... }:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit (value) modules;
          inherit pkgs;
        }
      )
    );
  };

}
