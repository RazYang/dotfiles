{ lib, my-lib, ... }:
my-lib.importSubfolders ./.
|> lib.setAttrByPath [
  "flake"
  "homeModules"
]
