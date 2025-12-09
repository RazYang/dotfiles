{ ... }:
{
  perSystem =
    { pkgs, inputs', ... }:
    {
      packages = {
        hello-custom = pkgs.callPackage ./hello-custom.nix { };
        #inherit (pkgs)
        #  hello
        #  zcf
        #  ;
        #nixvim = callPackage ./nixvim.nix { };
        hm = inputs'.home-manager.packages.home-manager;
      };
    };
}
