{ inputs, self, ... }:
{
  imports = [
    ./devshells
    ./bundlers
    ./apps
    ./services
    ./packages
    ./nixos
    ./darwin
    (inputs.import-tree ./modules)
  ];
}
