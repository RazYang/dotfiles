{
  lib,
  inputs,
  config,
  withSystem,
  ...
}:
{
  options.flake.modules = {
    hosts = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule {
          options = {
            system = lib.mkOption {
              type = lib.types.enum (import inputs.systems);
            };
            modules = lib.mkOption {
              type = lib.types.listOf lib.types.deferredModule;
            };
          };
        }
      );
    };
    nixos = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
    };
  };

  config = {
    flake.nixosConfigurations = lib.flip lib.mapAttrs config.flake.modules.hosts (
      _: value:
      withSystem value.system (
        { pkgs, ... }:
        lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit (config.flake.modules) users;
          };

          inherit (value) modules;
          inherit pkgs;
        }
      )
    );
  };

}
