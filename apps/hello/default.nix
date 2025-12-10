{ writeShellScriptBin, ... }:

let
  script = writeShellScriptBin "hello-flake" ''
    echo "Hello from Nix flake apps!"
    echo "This is a demo app exported from the flake."
  '';
in
{
  type = "app";
  program = "${script}/bin/hello-flake";
}
