{ lib, ... }:
let
  flakeLib = (import ../lib { inherit lib; }).flake.lib;
in
./. |> flakeLib.importSubfolders
