{
  lib,
  stdenv,
  writeShellScriptBin,
  inputs,
  inputs',
  ...
}:
let
  script =
    if stdenv.hostPlatform.isDarwin then
      let
        darwin-rebuild = lib.getExe inputs'.nix-darwin.packages.darwin-rebuild;
      in
      ''
        if [ "$#" -gt 0 ]; then
          exec sudo ${darwin-rebuild} switch --flake "${inputs.self}#''${@}"
        else
          exec sudo ${darwin-rebuild} switch --flake "${inputs.self}"
        fi
      ''
    else
      ''
        echo "darwin-switch is only supported on Darwin" >&2
        exit 1
      '';
in
writeShellScriptBin "darwin-switch" script
