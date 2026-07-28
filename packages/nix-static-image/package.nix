{
  cacert,
  dockerTools,
  lib,
  nix-static,
  pkgsStatic,
  ...
}:
let
  busybox = pkgsStatic.busybox;
in
dockerTools.streamLayeredImage {
  name = "nix";
  tag = "latest";

  extraCommands = ''
    mkdir -p etc/nix root tmp
    cp -a ${./etc}/. etc/
  '';

  fakeRootCommands = ''
    chown -R 0:0 .
    chmod 1777 tmp
  '';

  config = {
    Entrypoint = [ "nix" ];
    Cmd = [ "--version" ];
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
