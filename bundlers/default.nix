{
  lib,
  inputs,
  infuse,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.bundlers
  ];
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    let
      toFix = self: {
        callPackage = lib.callPackageWith (
          lib.mergeAttrsList [
            pkgs
            self.packages
            {
              inherit inputs infuse;
              inherit (config.allModuleArgs) self' inputs' system;
            }
          ]
        );
        packages = (
          lib.fileset.fileFilter ({ name, ... }: name == "bundler.nix") ./.
          |> lib.fileset.toList
          |> lib.map (path: {
            name = builtins.dirOf path |> builtins.baseNameOf;
            value = self.callPackage (import path) { };
          })
          |> lib.listToAttrs
        );
      };
    in
    {
      bundlers = (lib.fix toFix).packages;
    };
}
