{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { ... }:
    {
      treefmt = {
        flakeCheck = false;
        programs = {
          nixfmt = {
            enable = true;
            strict = true;

          };
          jsonfmt.enable = true;
        };
      };
    };
}
