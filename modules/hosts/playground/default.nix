{
  inputs,
  lib,
  config,
  ...
}:
{
  flake.modules.hosts.playground = {
    system = "x86_64-linux";
    modules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.impermanence.nixosModules.impermanence
      ./_configuration.nix
      ./_hardware-configuration.nix
    ];
  };
}
