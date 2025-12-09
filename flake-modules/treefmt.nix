{ inputs, withSystem, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem =
    { ... }:
    {
      treefmt = {
        flakeCheck = false;
        programs = {
          nixfmt.enable = true;
          jsonfmt.enable = true;
        };
      };
    };
}
