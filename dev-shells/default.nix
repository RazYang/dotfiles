{
  lib,
  inputs,
  myLib,
  ...
}:
{
  perSystem = args: {
    devshells = myLib.importSubfolders ./.;
  };
}
