{ lib, inputs, ... }: {
  imports = [
    (inputs.import-tree ./modules)
    inputs.devshell.flakeModule
    inputs.flake-by-folder.flakeModule
  ];

  flake-by-folder = {
    root = ./.;
    pkgsCross.enable = false;
    pkgsStatic.enable = false;
  };
}
