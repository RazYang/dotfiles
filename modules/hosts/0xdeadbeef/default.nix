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
      config.flake.modules.darwin.base
      ./_configuration.nix
    ];
  };
}
