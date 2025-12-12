{ inputs, self }:
{
  system = "x86_64-linux";
  modules = [
    self.nixosModules.common
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
