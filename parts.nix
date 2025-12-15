{ lib, inputs, ... }:
{
  imports = [
    (inputs.import-tree ./modules)
    ./packages
    ./bundlers
    ./devshells
    ./services
  ];
}
