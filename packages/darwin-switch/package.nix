{
  writeShellScriptBin,
  inputs,
  inputs',
  ...
}:
let
  nix-darwin = inputs'.nix-darwin.packages.default;
  darwin-rebuild = "${nix-darwin}/bin/darwin-rebuild";
in
writeShellScriptBin "darwin-switch" ''
  if [ "$#" -gt 0 ]; then
    exec sudo ${darwin-rebuild} switch --flake "${inputs.self}#''${@}"
  else
    exec sudo ${darwin-rebuild} switch --flake "${inputs.self}"
  fi
''
