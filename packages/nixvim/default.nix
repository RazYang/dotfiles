{ pkgs, inputs', ... }:
inputs'.nixvim.legacyPackages.makeNixvim (import ./config.nix { inherit pkgs; })
