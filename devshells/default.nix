{
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.devshell.flakeModule ];
  perSystem =
    { config, pkgs, ... }:
    let
      starshipConfig = pkgs.writers.writeTOML "starship.toml" { };
    in
    {
      devshells = (
        lib.fileset.fileFilter ({ name, ... }: name == "devshell.nix") ./.
        |> lib.fileset.toList
        |> lib.map (path: {
          name = builtins.dirOf path |> builtins.baseNameOf;
          value = {
            imports = [ (import path config.allModuleArgs) ];
            devshell = {
              motd = "";
              interactive.PS1.text = ''
                export STARSHIP_CONFIG=${starshipConfig}
                eval -- "''$(${pkgs.starship}/bin/starship init bash --print-full-init)"
              '';
            };
          };
        })
        |> lib.listToAttrs
      );
    };
}
