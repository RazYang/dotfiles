{
  writeShellScriptBin,
  inputs,
  inputs',
  ...
}:
let
  homeManager = inputs'.home-manager.packages.home-manager;
  hmBin = "${homeManager}/bin/home-manager";
in
writeShellScriptBin "hm-switch" ''
  if [ "$#" -gt 0 ]; then
    exec ${hmBin} switch --flake "${inputs.self}#''${@}"
  else
    exec ${hmBin} switch --flake "${inputs.self}"
  fi
''
