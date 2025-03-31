{ inputs, pkgs }:
let
  callPackage = file: args: pkgs.callPackage file ({ inherit inputs; } // args);
in
rec {
  test = callPackage ./test { };
  testStatic = callPackage ./test { static = true; };
  nixvim = callPackage ./nixvim.nix { };
  rootfs = inputs.nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    specialArgs = {
      inherit pkgs;
    };
    modules = [
      {
      }
    ];
    format = "raw";
  };

  inherit (pkgs) hello;
  inherit (pkgs) mongodb;
  default = hello;
}
