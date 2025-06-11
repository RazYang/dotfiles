{ inputs, pkgs }:
let
  callPackage = file: args: pkgs.callPackage file ({ inherit inputs; } // args);
in
rec {
  test = callPackage ./test { };
  testStatic = callPackage ./test { static = true; };
  nixvim = callPackage ./nixvim.nix { };
  inherit (pkgs) hello;
  inherit (pkgs) mongodb;
  testos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      {boot.isContainer = true; }
    ];
  };
  zig = pkgs.zigPackages.zig;
  rootfs = inputs.nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    specialArgs = {
      inherit pkgs;
    };
    modules = [
      {
        boot.isContainer = true;
      }
    ];

    format = "lxc";

  };
  home-manager = inputs.home-manager.packages.x86_64-linux.home-manager;
  default = hello;
}
