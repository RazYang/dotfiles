{
  lib,
  my-lib,
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
        packages = (my-lib.importSubfolders ./. |> lib.mapAttrs (_: pkgFn: self.callPackage pkgFn { }));
      };
    in
    {
      inherit (lib.fix toFix) packages;
    };
}
