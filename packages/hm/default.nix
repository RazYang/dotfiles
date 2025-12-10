{ pkgs, inputs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
in
inputs.home-manager.packages.${system}.home-manager
