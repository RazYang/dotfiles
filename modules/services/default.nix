{
  lib,
  inputs,
  infuse,
  ...
}:
{
  imports = [
    inputs.process-compose-flake.flakeModule
  ];
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      process-compose."myservices" =
        { ... }:
        {
          imports = [
            inputs.services-flake.processComposeModules.default
          ];
          services.postgres.pg.enable = true;
          services.redis.rd.enable = true;
        };
    };

  flake-file.inputs = {
    services-flake.url = "https://github.com/juspay/services-flake/archive/8b6244f.zip";
    process-compose-flake.url = "https://github.com/Platonic-Systems/process-compose-flake/archive/3667881.zip";
  };
}
