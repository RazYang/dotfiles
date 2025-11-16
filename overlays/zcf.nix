{
  stdenv,
  pnpm,
  npmHooks,
  fetchFromGitHub,
  nodejs,
}:
stdenv.mkDerivation (final: {
  pname = "zcf";
  version = "3.3.3";
  src = fetchFromGitHub {
    owner = "UfoMiao";
    repo = "zcf";
    tag = "${final.pname}@${final.version}";
    hash = "sha256-OoIc+Zg9ahei1+Mp7nE3G5OzbCyq4wGdYGzkfGTb6Qw=";
  };
  pnpmDeps = pnpm.fetchDeps {
    inherit (final) pname version src;
    fetcherVersion = 2;
    hash = "sha256-cxEIuqCwsg9DCZ8aDXcQ0e3CaAtt+iufmijOsgPQ4H8=";
  };
  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    npmHooks.npmInstallHook
  ];
  buildPhase = ''
    runHook preBuild
    pnpm run build 
    runHook postBuild
  '';
  dontNpmPrune = true;
})
