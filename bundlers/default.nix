{
  lib,
  inputs,
  infuse,
  config,
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
        packages =
          config.flake.lib.importSubfolders ./. |> lib.mapAttrs (_: pkgFn: self.callPackage pkgFn { });
      };
    in
    {
      bundlers = (lib.fix toFix).packages;
    };
}
