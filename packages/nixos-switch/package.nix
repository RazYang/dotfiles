{
  writeShellScriptBin,
  inputs,
  inputs',
  nixos-rebuild-ng,
  ...
}:
let
  nixos-rebuild = "${nixos-rebuild-ng}/bin/nixos-rebuild-ng";
in
writeShellScriptBin "nixos-switch" ''
  if [ "$#" -gt 0 ]; then
    exec ${nixos-rebuild} switch --flake "${inputs.self}#''${@}"
  else
    exec ${nixos-rebuild} switch --flake "${inputs.self}"
  fi
''
