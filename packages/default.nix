{
  lib,
  config,
  inputs,
  infuse,
  ...
}:
{
  perSystem =
    { pkgs, config, ... }:
    let
      toFix = self: {
        callPackage =
          pkgsArg:
          lib.callPackageWith (
            lib.mergeAttrsList [
              pkgsArg
              self.packages
              {
                inherit inputs infuse;
                inherit (config.allModuleArgs) self' inputs' system;
              }
            ]
          );
        myPkgs =
          callPackage:
          (
            lib.fileset.fileFilter ({ name, ... }: name == "package.nix") ./.
            |> lib.fileset.toList
            |> lib.map (path: {
              name = builtins.dirOf path |> builtins.baseNameOf;
              value = callPackage (import path) { };
            })
            |> lib.listToAttrs
          );
        packages = (self.myPkgs (self.callPackage pkgs)) // {
          pkgsCross =
            (pkgs.writeText "pkgsCross" "")
            // (
              lib.map (crossSystem: {
                name = crossSystem;
                value = self.myPkgs (self.callPackage pkgs.pkgsCross."${crossSystem}");
              }) (lib.attrNames lib.systems.examples)
              |> lib.listToAttrs
            );
        };
      };
    in
    {
      inherit (lib.fix toFix) packages;
    };
}
