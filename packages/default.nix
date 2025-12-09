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
        nixvim = inputs'.nixvim.legacyPackages.makeNixvim (import ./nixvim.nix { inherit pkgs; });
        hm = inputs'.home-manager.packages.home-manager;
      };
    };
}
