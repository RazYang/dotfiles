{ inputs, ... }:
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

  flake-file.inputs.treefmt-nix = {
    url = "https://github.com/numtide/treefmt-nix/archive/5b4ee75.zip";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
