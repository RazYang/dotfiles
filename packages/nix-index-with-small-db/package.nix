{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  pkgs,
  ...
}:
let
  # nix-index-database release info
  releaseVersion = "2026-07-26-054738";

  # Map Nix system triplets to nix-index-database asset names
  systemMap = {
    x86_64-linux = "x86_64-linux";
    aarch64-linux = "aarch64-linux";
    aarch64-darwin = "aarch64-darwin";
  };

  # Get the correct asset name for current system
  system =
    systemMap.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  # Download the small database for the current system
  db = fetchurl {
    url = "https://github.com/nix-community/nix-index-database/releases/download/${releaseVersion}/index-${system}-small";
    sha256 =
      {
        x86_64-linux = "be64be33a52039c30664056f52aa77910294349e01ea4a53a1de559a85d3fc8c";
        aarch64-linux = "460ea550d8dbcb2703c875d017740a84181955c9e7e1b811e041a69eb426a955";
        aarch64-darwin = "7f9b57ea3031ee570f013723d64867d6a85ff3a9f0040fc8cbf92a5d3bd95b3b";
      }
      .${stdenv.hostPlatform.system} or lib.fakeHash;
  };
in
stdenv.mkDerivation {
  pname = "nix-index-with-small-db";
  version = releaseVersion;

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Create the database directory and link the database file
    mkdir -p $out/share/nix-index
    ln -s ${db} $out/share/nix-index/files

    # Wrap all executables from nix-index and comma
    mkdir -p $out/bin
    for exe in ${pkgs.nix-index}/bin/*; do
      local name=$(basename $exe)
      makeWrapper $exe $out/bin/$name \
        --set NIX_INDEX_DATABASE $out/share/nix-index
    done
    makeWrapper ${pkgs.comma}/bin/comma $out/bin/comma \
      --set NIX_INDEX_DATABASE $out/share/nix-index
    ln -s $out/bin/comma $out/bin/,

    # Install command-not-found scripts with correct nix-locate path
    mkdir -p $out/etc/profile.d
    substitute ${./etc/profile.d/command-not-found.sh} $out/etc/profile.d/command-not-found.sh \
      --replace-fail "@nix-locate@" "$out/bin/nix-locate"

    runHook postInstall
  '';

  meta = {
    description = "nix-index with pre-built small database from nix-index-database";
    mainProgram = pkgs.nix-index.meta.mainProgram or "nix-index";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
