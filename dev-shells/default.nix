{
  lib,
  inputs,
  myLib,
  ...
}:
{
  imports = [
    inputs.devshell.flakeModule
  ];
  perSystem = args: {
    devshells = myLib.importSubfolders ./.;
  };
}
