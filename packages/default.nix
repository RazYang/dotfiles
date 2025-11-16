{ inputs, pkgs }:
let
  callPackage = file: args: pkgs.callPackage file ({ inherit inputs; } // args);
in
{
  hello-custom = callPackage ./hello-custom.nix { };
  inherit (pkgs)
    hello
    codex
    zcf
    ;
  nixvim = callPackage ./nixvim.nix { };
  hm = inputs.home-manager.packages.x86_64-linux.home-manager;
}
