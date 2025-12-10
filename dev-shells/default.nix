{
  lib,
  inputs,
  myLib,
  ...
}:
{
  perSystem = args: {
    devshells = myLib.importSubfolders ./.;

  };
  /*
    |> lib.mapAttrs (_: v: v args)
     |> lib.setAttrByPath [
       "devShells"
     ];
  */
}
