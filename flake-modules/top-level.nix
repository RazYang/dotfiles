{
  inputs,
  lib,
  systems,
  my-lib,
  ...
}:
let
  flakeModules = my-lib.importSubfolders ./.;
in
{
  inherit systems;
  imports = [
    ../packages
    ../services
    ../dev-shells
    ../bundlers
    ../apps
    ../home
    ../nixos
    ../darwin
  ]
  ++ (flakeModules |> lib.attrValues);
  flake.flakeModules = flakeModules;
}
