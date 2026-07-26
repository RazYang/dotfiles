{
  lib,
  writeShellScriptBin,
  inputs,
  inputs',
  nixos-rebuild-ng,
  ...
}:
writeShellScriptBin "nixos-switch" ''
  if [ "$#" -gt 0 ]; then
    exec ${lib.getExe nixos-rebuild-ng} switch --flake "${inputs.self}#''${@}"
  else
    exec ${lib.getExe nixos-rebuild-ng} switch --flake "${inputs.self}"
  fi
''
