{
  cacert,
  dockerTools,
  lib,
  nix-static,
  pkgs,
  pkgsStatic,
  ...
}:
let
  bash = pkgsStatic.bash;
  busybox = pkgsStatic.busybox;
  strip = "${pkgsStatic.stdenv.cc.bintools.bintools}/bin/${pkgsStatic.stdenv.cc.targetPrefix}strip";

  # Build an FHS environment containing the static Nix and BusyBox executables.
  # Static Bash is copied into the final rootfs below.
  # The rootfs (accessible via passthru.fhsenv) is a symlink farm laid out in
  # standard FHS paths (usr/bin, usr/lib, …) whose links point into /nix/store.
  fhs = pkgs.buildFHSEnv {
    pname = "nix";
    version = "latest";
    targetPkgs = _pkgs: [
      nix-static
      busybox
      cacert
    ];
    runScript = "nix";
    extraBuildCommands = ''
      cp -a ${./etc}/. $out/etc/
    '';
  };

  rootfs = fhs.passthru.fhsenv;
in
dockerTools.streamLayeredImage {
  name = "nix";
  tag = "latest";

  # The customisation layer already contains dereferenced (real) files, so we
  # don't need the Nix store closure as separate Docker layers.
  includeStorePaths = false;

  extraCommands = ''
    # Store paths whose FHS symlinks we want to dereference.  buildFHSEnv
    # also pulls in base packages (glibc, bash, coreutils, …) whose symlinks
    # we will simply discard.
    nix_path="${nix-static}"
    bb_path="${busybox}"
    cert_path="${cacert}"

    # Copy the FHS rootfs (symlink farm pointing into /nix/store)
    cp -a ${rootfs}/. .
    chmod -R u+w .
    rm -rf nix-support

    # Dereference only the symlinks that belong to OUR packages, replacing
    # each with the real file or a relative symlink.  Two passes avoid
    # duplicating files reached via intermediate symlinks (e.g. busybox
    # applets → busybox).
    declare -A file_map

    # Pass 1: copy files whose immediate target is a regular file.
    while IFS= read -r link; do
      target=$(readlink "$link")
      case "$target" in
        "$nix_path"*|"$bb_path"*|"$cert_path"*)
          if [ ! -L "$target" ] && [ -e "$target" ]; then
            rm "$link"
            cp -a "$target" "$link"
            file_map["$target"]="$link"
          fi
          ;;
      esac
    done < <(find . -type l -lname '/nix/store/*' | sort)

    # Pass 2: for symlinks whose immediate target is itself a symlink,
    # resolve to the final regular file and create a relative symlink to
    # the already-copied FHS path.
    while IFS= read -r link; do
      target=$(readlink "$link")
      case "$target" in
        "$nix_path"*|"$bb_path"*|"$cert_path"*)
          [ -L "$target" ] || continue
          final=$(readlink -f "$link" 2>/dev/null) || continue
          [ -e "$final" ] || continue
          existing="''${file_map[$final]:-}"
          if [ -n "$existing" ]; then
            rm "$link"
            ln -s "$(realpath --relative-to="$(dirname "$link")" "$existing")" "$link"
          else
            rm "$link"
            cp -a "$final" "$link"
            file_map["$final"]="$link"
          fi
          ;;
      esac
    done < <(find . -type l -lname '/nix/store/*' | sort)

    # Remove all remaining /nix/store symlinks — these belong to the
    # buildFHSEnv base packages (glibc, bash, coreutils, …) which we don't
    # need because our binaries are fully static.
    find . -type l -lname '/nix/store/*' -delete

    cp -a ${bash}/bin/bash usr/bin/bash
    test "$(readlink bin)" = /usr/bin
    ln -sfn bash usr/bin/sh

    while IFS= read -r -d "" candidate; do
      case "$(${pkgs.file}/bin/file --brief "$candidate")" in
        ELF\ *)
          chmod u+w "$candidate"
          ${strip} --strip-all "$candidate"
          ;;
      esac
    done < <(find . -type f -print0)

    # Clean up empty directories left behind by the base packages
    find . -type d -empty -delete

    # Recreate runtime directories
    mkdir -p root tmp
  '';

  fakeRootCommands = ''
    chown -R 0:0 .
    chmod 1777 tmp
  '';

  config = {
    Entrypoint = [ "nix" ];
    Cmd = [ "--version" ];
    Env = [
      "ENV=/etc/bashrc"
      "HOME=/root"
      "USER=root"
      "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
      "PATH=/usr/bin:/usr/sbin:/bin:/sbin"
    ];
    WorkingDir = "/root";
  };

  meta = {
    description = "FHS image with flattened Nix, Bash, and BusyBox executables (no /nix directory)";
    platforms = lib.platforms.linux;
  };
}
