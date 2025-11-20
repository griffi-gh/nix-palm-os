{
  pname,
  sdkDir,
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  inherit pname;
  version = "unstable-2023-12-19";

  src = fetchFromGitHub {
    owner = "jichu4n";
    repo = "palm-os-sdk";
    rev = "1fa22066ca0f8b74949c14dd1d626294145d1c09";
    hash = "sha256-sj5MmNSO+Pr3ipIbOhmUC4uYWdoCvcKj4tzguoJ0lCw=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r ./${sdkDir}/* $out/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Palm OS SDK";
    homepage = "https://github.com/jichu4n/palm-os-sdk";
    platforms = platforms.all;
    maintainers = [ ];
  };
}
