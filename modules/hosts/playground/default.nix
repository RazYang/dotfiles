{
  inputs,
  lib,
  config,
  ...
}:
{
  flake.modules.hosts.playground = {
    type = "nixos";
    system = "x86_64-linux";
    modules = [
      config.flake.modules.nixos.base
      inputs.home-manager.nixosModules.home-manager
      inputs.impermanence.nixosModules.impermanence
      ./_configuration.nix
      ./_hardware-configuration.nix
    ];
  };
}
