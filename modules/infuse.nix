{ inputs, lib, ... }:
{
  _module.args.infuse = (import inputs.infuse { inherit lib; }).v1.infuse;
}
