{
  inputs,
  lib,
  systems,
  myLib,
  ...
}:
lib.fix (final: {
  inherit systems;
  imports = [
    inputs.home-manager.flakeModules.home-manager
    ../packages
    ../dev-shells
    ../bundlers
    ../home
    ../nixos
    ../darwin
  ]
  ++ (lib.attrValues final.flake.flakeModules);

  flake.lib = myLib;
  flake.flakeModules = myLib.importSubfolders ./.;
})
