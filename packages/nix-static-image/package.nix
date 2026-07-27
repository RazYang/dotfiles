{
  cacert,
  closureInfo,
  dockerTools,
  lib,
  nix-static,
  pkgsStatic,
  writeTextDir,
  ...
}:
let
  busybox = pkgsStatic.busybox;
  nixConfig = writeTextDir "etc/nix/nix.conf" (builtins.readFile ./nix.conf);
  flakeRegistry = writeTextDir "etc/nix/flake-registry.json" (
    builtins.toJSON {
      version = 2;
      flakes = [
        {
          from = {
            type = "indirect";
            id = "nixpkgs";
          };
          exact = true;
          to = {
            type = "tarball";
            url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";
          };
        }
      ];
    }
  );
  runtimeClosure = closureInfo {
    rootPaths = [
      cacert
      busybox
      nix-static
    ];
  };
in
dockerTools.streamLayeredImage {
  name = "nix-static";
  tag = "latest";

  # Copy the validated runtime closure without adding a Nix database.
  includeStorePaths = false;

  extraCommands = ''
    mkdir -p etc/nix nix/store root tmp
    cp ${nixConfig}/etc/nix/nix.conf etc/nix/nix.conf
    cp ${flakeRegistry}/etc/nix/flake-registry.json etc/nix/flake-registry.json

    while IFS= read -r storePath; do
      case "$storePath" in
        /nix/store/*-glibc-[0-9]*)
          echo "unexpected glibc path in the image runtime closure: $storePath" >&2
          exit 1
          ;;
        /nix/store/*musl-*-dev)
          echo "unexpected musl development path in the image runtime closure: $storePath" >&2
          exit 1
          ;;
      esac

      cp -a "$storePath" nix/store/
    done < ${runtimeClosure}/store-paths
  '';

  fakeRootCommands = ''
    chown -R 0:0 .
    chmod 1777 tmp
  '';

  config = {
    Cmd = [
      "nix"
      "--version"
    ];
    Env = [
      "HOME=/root"
      "USER=root"
      "NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt"
      "PATH=/root/.nix-profile/bin:${
        lib.makeBinPath [
          nix-static
          busybox
        ]
      }"
    ];
    WorkingDir = "/root";
  };

  meta = {
    description = "Minimal image containing fully static Nix and BusyBox executables";
    platforms = lib.platforms.linux;
  };
}
