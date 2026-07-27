{
  lib,
  nixStatic,
  runCommand,
}:
let
  nixStaticCli = nixStatic.nix-cli;
  strip = "${nixStatic.stdenv.cc.bintools.bintools}/bin/${nixStatic.stdenv.cc.targetPrefix}strip";
in
runCommand nixStaticCli.name
  {
    disallowedReferences = [ nixStaticCli ] ++ (nixStaticCli.propagatedBuildInputs or [ ]);

    meta = (nixStaticCli.meta or { }) // {
      description = "Fully static Nix without development outputs in its runtime closure";
      platforms = lib.platforms.linux;
    };
  }
  ''
    cp -a ${nixStaticCli}/. "$out"
    chmod -R u+w "$out"

    rm -f "$out/nix-support/propagated-build-inputs"

    if [ "''${#out}" -ne ${toString (builtins.stringLength "${nixStaticCli}")} ]; then
      echo "cannot rewrite the embedded Nix store path with a path of a different length" >&2
      exit 1
    fi
    sed -i "s|${nixStaticCli}|$out|g" \
      "$out/bin/nix" \
      "$out/lib/systemd/system/nix-daemon.service"

    ${strip} --strip-all "$out/bin/nix"
  ''
