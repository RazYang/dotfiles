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
  perSystem = args: {
    devshells = config.flake.lib.importSubfolders ./.;
  };
}
