{ infuse, nixpkgs, ... }:
{
  infuse = _: _: {
    inherit ((import infuse { inherit (nixpkgs) lib; }).v1) infuse;
  };
  default = _final: prev: {
    factorio = prev.callPackage ./factorio.nix { };

    # example
    hello = prev.hello.overrideAttrs (_oldAttrs: rec {
      version = "2.12";
      src = prev.fetchurl {
        url = "mirror://gnu/hello/hello-${version}.tar.gz";
        hash = "sha256-zwSvhtwIUmjF9EcPuuSbGK+8Iht4CWqrhC2TSna60Ks=";
      };
    });
  };
}
