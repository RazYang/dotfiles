{
  infuse,
  nixpkgs,
  codex,
  ...
}@args:
{
  infuse = _: _: {
    inherit ((import infuse { inherit (nixpkgs) lib; }).v1) infuse;
  };
  default = _final: prev: {
    #factorio = prev.callPackage ./factorio.nix { };
    codex = args.codex.packages.${prev.system}.default;
    zcf = prev.callPackage ./zcf.nix { };
  };
}
