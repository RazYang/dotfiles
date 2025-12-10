{ pkgs, homeManager }:
let
  hmBin = "${homeManager}/bin/home-manager";
in
pkgs.writeShellScriptBin "hm-switch" ''
  #!/usr/bin/env bash
  set -euo pipefail

  flake="''${HM_SWITCH_FLAKE:-.}"
  if [ "$#" -gt 0 ]; then
    exec ${hmBin} switch --flake "''${@}"
  else
    exec ${hmBin} switch --flake "''${flake}"
  fi
''
