{
  lib,
  inputs,
  config,
  ...
}:
let
  inherit (config.flake.lib) importSubfolders infuse;
in
{
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    let
      toFix = self: {
        callApp =
          appFn: args:
          lib.callPackageWith (lib.mergeAttrsList [
            pkgs
            {
              inherit inputs infuse;
              inherit (config.allModuleArgs) self' inputs' system;
            }
          ]) appFn args
          |> lib.filterAttrs (n: _: n != "override" && n != "overrideDerivation");
        apps = (importSubfolders ./. |> lib.mapAttrs (_: appFn: self.callApp appFn { }));
      };
    in
    {
      apps = (lib.fix toFix).apps;
    };
}
