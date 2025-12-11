{
  lib,
  inputs,
  my-lib,
  ...
}:
{
  imports = [
    inputs.devshell.flakeModule
  ];
  perSystem = args: {
    devshells = my-lib.importSubfolders ./.;
  };
}
