{ inputs, pkgs }:
let
  callPackage = file: args: pkgs.callPackage file ({ inherit inputs; } // args);
in
{
  hello-custom = callPackage ./hello-custom.nix { };
  inherit (pkgs)
    hello
    zcf
    ;
  nixvim = callPackage ./nixvim.nix { };
  hm = inputs.home-manager.packages.${pkgs.system}.home-manager;
  darwin-rebuild = inputs.nix-darwin.packages.${pkgs.system}.darwin-rebuild;
}
