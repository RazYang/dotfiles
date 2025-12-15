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
            type = lib.mkOption {
              type = lib.types.enum [
                "nixos"
                "darwin"
              ];
            };
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
    darwin = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
    };
  };

  config = {
    flake.nixosConfigurations =
      config.flake.modules.hosts
      |> lib.filterAttrs (name: value: value.type == "nixos")
      |> lib.mapAttrs (
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
    flake.darwinConfigurations =
      config.flake.modules.hosts
      |> lib.filterAttrs (name: value: value.type == "darwin")
      |> lib.mapAttrs (
        _: value:
        withSystem value.system (
          { pkgs, ... }:
          lib.darwinSystem {
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
