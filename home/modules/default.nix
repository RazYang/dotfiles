{ lib, self, ... }:
self.lib.importSubfolders ./.
|> lib.setAttrByPath [
  "flake"
  "homeModules"
]
