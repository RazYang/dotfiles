{ ... }:
{
  flake.modules.home.base =
    { inputs, inputs', ... }:
    {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];
      programs = {
        nix-index-database.comma.enable = true;
        nix-index = {
          enable = true;
          package = inputs'.nix-index-database.packages.nix-index-with-small-db;
        };
      };
    };
}
