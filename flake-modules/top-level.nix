{
  inputs,
  lib,
  systems,
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

  flake.lib = import ../lib { inherit (inputs.nixpkgs-lib) lib; };
  flake.flakeModules = final.flake.lib.importSubfolders ./.;
})
