{ lib, inputs, ... }:
{
  _module.args.infuse = (import inputs.infuse { inherit lib; }).v1.infuse;

  imports = [
    ./devshells
    ./bundlers
    ./services
    ./packages
    #./nixos
    (inputs.import-tree ./modules)
  ];
}
