{
  inputs,
  lib,
  config,
  ...
}:
{
  flake.modules.hosts."0xdeadbeef" = {
    type = "darwin";
    system = "aarch64-darwin";
    modules = [
      inputs.home-manager.darwinModules.home-manager
      ./_configuration.nix
    ];
  };
}
