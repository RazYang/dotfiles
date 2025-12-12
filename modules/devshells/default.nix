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

  flake-file.inputs.devshell = {
    url = "https://github.com/numtide/devshell/archive/17ed8d9.zip";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
