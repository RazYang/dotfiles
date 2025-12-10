{
  lib,
  inputs,
  myLib,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.bundlers
  ];
  perSystem =
    { pkgs, inputs', ... }:
    let
      toFix = self: {
        callPackage = lib.callPackageWith (
          lib.mergeAttrsList [
            pkgs
            self.packages
            ({ inherit inputs inputs'; })
          ]
        );
        packages = myLib.importSubfolders ./. |> lib.mapAttrs (_: pkgFn: self.callPackage pkgFn { });
      };
    in
    {
      bundlers = (lib.fix toFix).packages;
    };
}
