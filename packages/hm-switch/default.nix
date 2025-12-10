{ pkgs, inputs }:
let
  system = pkgs.stdenv.hostPlatform.system;
  homeManager = inputs.home-manager.packages.${system}.home-manager;
  hmBin = "${homeManager}/bin/home-manager";
in
pkgs.writeShellScriptBin "hm-switch" ''
  #!/usr/bin/env bash
  set -euo pipefail
  if [ "$#" -gt 0 ]; then
    exec ${hmBin} switch --flake "''${inputs.self}#''${@}"
  else
    exec ${hmBin} switch --flake "''${inputs.self}"
  fi
''
