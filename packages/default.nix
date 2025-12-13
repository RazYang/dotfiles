{
  lib,
  config,
  inputs,
  infuse,
  ...
}:
{
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
          lib.fileset.fileFilter ({ name, ... }: name == "package.nix") ./.
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
      inherit (lib.fix toFix) packages;
    };
}
