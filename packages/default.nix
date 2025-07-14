{ inputs, pkgs }:
let
  callPackage = file: args: pkgs.callPackage file ({ inherit inputs; } // args);
in
{
  nixvim = callPackage ./nixvim.nix { };
  hm = inputs.home-manager.packages.x86_64-linux.home-manager;
}
