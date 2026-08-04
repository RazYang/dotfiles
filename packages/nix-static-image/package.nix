{
  cacert,
  lib,
  nix-static,
  nix2container,
  pkgsStatic,
  runCommand,
  ...
}:
let
  staticBash = pkgsStatic.bash;
  staticBusybox = pkgsStatic.busybox;
  strip = "${pkgsStatic.stdenv.cc.bintools.bintools}/bin/${pkgsStatic.stdenv.cc.targetPrefix}strip";

  rootfs =
    runCommand "nix-static-rootfs"
      {
        __structuredAttrs = true;
        # Runtime files are copied to /, not used through these build-time paths.
        unsafeDiscardReferences.out = true;
      }
      ''
        mkdir -p "$out"/{etc,root,tmp,usr/bin}
        cp -a ${nix-static}/{libexec,share} "$out/usr/"
        cp -a ${nix-static}/bin/* ${staticBusybox}/bin/* ${staticBash}/bin/bash "$out/usr/bin/"
        cp -a ${cacert}/etc/* ${./etc}/* "$out/etc/"
        chmod -R u+w "$out"

        ln -sfn bash "$out/usr/bin/sh"
        ln -s bin "$out/usr/sbin"
        ln -s usr/bin "$out/bin"
        ln -s usr/sbin "$out/sbin"
        ln -s usr/libexec "$out/libexec"
        ln -s /proc/mounts "$out/etc/mtab"

        ${strip} --strip-all "$out/usr/bin/"{nix,bash,busybox}

        if find "$out" -type l -lname '/nix/store/*' -print -quit | grep -q .; then
          echo "rootfs contains symlinks into /nix/store" >&2
          exit 1
        fi
      '';
in
# /nix is intentionally absent; mount it at runtime for the standard Nix store.
nix2container.buildImage {
  name = "nix";
  tag = "latest";
  copyToRoot = rootfs;
  initializeNixDatabase = false;
  maxLayers = 1;

  perms = [
    {
      path = rootfs;
      regex = "${rootfs}/root$";
      mode = "0700";
    }
    {
      path = rootfs;
      regex = "${rootfs}/tmp$";
      mode = "1777";
    }
  ];

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

  meta.platforms = lib.platforms.linux;
}
