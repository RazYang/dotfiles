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
