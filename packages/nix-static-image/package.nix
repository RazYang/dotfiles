{
  cacert,
  dockerTools,
  lib,
  coreutils,
  gitMinimal,
  bash,
  pkgs,
  nix-static,
  ...
}:
dockerTools.streamLayeredImage {
  name = "nix-static";
  tag = "latest";

  contents = [ (pkgs.writeTextDir "etc/nix/nix.conf" (builtins.readFile ./nix.conf)) ];

  extraCommands = ''
    mkdir -p root tmp
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
      "PATH=${
        lib.makeBinPath [
          nix-static
          bash
          coreutils
          gitMinimal
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
