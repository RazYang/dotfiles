{ lib, ... }:
lib.fix (final: {
  importSubfolders =
    directory:
    builtins.readDir directory
    |> lib.filterAttrs (n: v: v == "directory")
    |> builtins.attrNames
    |> builtins.map (filename: {
      name = filename;
      value = import (directory + "/${filename}");
    })
    |> builtins.listToAttrs;
})
