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
}
