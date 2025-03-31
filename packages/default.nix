{ inputs, pkgs }:
let
  callPackage = file: args: pkgs.callPackage file ({ inherit inputs; } // args);
in
rec {
  test = callPackage ./test { };
  testStatic = callPackage ./test { static = true; };
  nixvim = callPackage ./nixvim.nix { };
  t = pkgs.runCommand "t" {
      __structuredAttrs = true;
      exportReferencesGraph.closure = nixvim;
      PATH = "${pkgs.coreutils}/bin";
      builder = builtins.toFile "builder" ''
        . .attrs.sh
        cp .attrs.json ''${outputs[out]}
      '';

  } ""; 
  inherit (pkgs) hello;
  inherit (pkgs) mongodb;
  default = hello;
}
