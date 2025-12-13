{ lib, inputs, ... }:
{
  _module.args.infuse = (import inputs.infuse { inherit lib; }).v1.infuse;

  imports = [
    ./devshells
    ./bundlers
    ./services
    ./nixos
    ./darwin
    ./packages
    (inputs.import-tree ./modules)
  ];
}
