{ pkgs }:
{
  inherit (pkgs) hello;
  #nixvim = callPackage ./nixvim.nix { };
  #hm = inputs.home-manager.packages.x86_64-linux.home-manager;
}
