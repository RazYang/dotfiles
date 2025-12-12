{ lib, config, ... }:
config.flake.lib.importSubfolders ./.
|> lib.setAttrByPath [
  "flake"
  "homeModules"
]
