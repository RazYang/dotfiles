{
  infuse,
  nixpkgs,
  ...
}:
{
  infuse = _: _: {
    inherit ((import infuse { inherit (nixpkgs) lib; }).v1) infuse;
  };
  default = _final: prev: {
    #factorio = prev.callPackage ./factorio.nix { };
    zcf = prev.callPackage ./zcf.nix { };
  };
}
