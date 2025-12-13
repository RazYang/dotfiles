{ inputs, lib, ... }:
{
  flake.modules.home.base =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];
      programs = {
        nix-index-database.comma.enable = true;
        nix-index = {
          enable = true;
          package =
            inputs.nix-index-database.packages."${pkgs.stdenv.hostPlatform.system}".nix-index-with-small-db;
        };
      };
    };
}
