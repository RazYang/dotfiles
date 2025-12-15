{
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.devshell.flakeModule
  ];
  perSystem =
    { config, ... }:
    {
      devshells =
        lib.fileset.fileFilter ({ name, ... }: name == "devshell.nix") ./.
        |> lib.fileset.toList
        |> lib.map (path: {
          name = builtins.dirOf path |> builtins.baseNameOf;
          value = import path config.allModuleArgs;
        })
        |> lib.listToAttrs;
    };
}
