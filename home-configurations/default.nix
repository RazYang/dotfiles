{ inputs, pkgsWithSystem }:
{
  "root@playground" = import ./root {
    inherit inputs;
    pkgs = pkgsWithSystem "x86_64-linux";
  };
  "razyang" = import ./razyang {
    inherit inputs;
    pkgs = pkgsWithSystem "x86_64-linux";
  };
  "yang@macbook.lan" = import ./yang {
    inherit inputs;
    pkgs = pkgsWithSystem "aarch64-darwin";
  };
  "ctf@0xdeadbeef" = import ./ctf {
    inherit inputs;
    pkgs = pkgsWithSystem "x86_64-linux";
  };
}
