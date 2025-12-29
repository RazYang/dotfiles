{ lib, inputs, ... }:
{
  imports = [
    (inputs.import-tree ./modules)
    ./overlays
    ./packages
    ./devshells
  ];
}
