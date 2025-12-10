{
  lib,
  myLib,
  inputs,
  infuse,
  ...
}:
{
  imports = [
    inputs.process-compose-flake.flakeModule
  ];
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
        apps = (myLib.importSubfolders ./. |> lib.mapAttrs (_: appFn: self.callApp appFn { }));
      };
    in
    {
      apps = (lib.fix toFix).apps;
      process-compose = {
        test = {
          settings.processes.hello.command = "sleep 1000";
          settings.processes.world.command = "sleep 1000";
        };
      };
    };
}
