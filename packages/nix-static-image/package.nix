{
  busybox,
  cacert,
  closureInfo,
  dockerTools,
  glibc,
  lib,
  nix-static,
  writeTextDir,
  ...
}:
let
  nixConfig = writeTextDir "etc/nix/nix.conf" (builtins.readFile ./nix.conf);
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

  # Put the runtime closure in this layer so glibc can be pruned before it is
  # archived. Deleting it from a later layer would not reduce the image size.
  # The pruned store path must not be registered in a Nix database because its
  # contents intentionally differ from the original NAR.
  includeStorePaths = false;

  extraCommands = ''
    mkdir -p etc/nix nix/store root tmp
    cp ${nixConfig}/etc/nix/nix.conf etc/nix/nix.conf

    trimmedGlibc=0
    while IFS= read -r storePath; do
      cp -a "$storePath" nix/store/

      case "$storePath" in
        ${lib.escapeShellArg "${glibc}"})
          imagePath="nix/store/''${storePath##*/}"
          chmod u+w "$imagePath/lib" "$imagePath/share"
          # Keep the small C.UTF-8 locale while dropping generated locale data
          # and legacy character-set converters.
          for path in \
            "$imagePath/lib/gconv" \
            "$imagePath/share/i18n" \
            "$imagePath/share/locale"
          do
            if [ -e "$path" ]; then
              chmod -R u+w "$path"
              rm -rf "$path"
            fi
            test ! -e "$path"
          done
          chmod u-w "$imagePath/lib" "$imagePath/share"
          test -f "$imagePath/lib/libc.so.6"
          test -d "$imagePath/lib/locale/C.utf8"
          trimmedGlibc=1
          ;;
        /nix/store/*-glibc-[0-9]*)
          echo "unexpected glibc path in the image runtime closure: $storePath" >&2
          exit 1
          ;;
      esac
    done < ${runtimeClosure}/store-paths

    if [ "$trimmedGlibc" -ne 1 ]; then
      echo "no glibc path found in the image runtime closure" >&2
      exit 1
    fi
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
    description = "Minimal image containing a mixed-static Nix executable";
    platforms = lib.platforms.linux;
  };
}
