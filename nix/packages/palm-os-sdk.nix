{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
let
  mkPalmSdk =
    pname: sdkDir:
    stdenvNoCC.mkDerivation {
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
    };
in
{
  PalmOne = mkPalmSdk "palm-os-sdk.PalmOne" "sdk-PalmOne";
  sdk-1 = mkPalmSdk "palm-os-sdk.sdk-1" "sdk-1";
  sdk-2 = mkPalmSdk "palm-os-sdk.sdk-2" "sdk-2";
  sdk-3-1 = mkPalmSdk "palm-os-sdk.sdk-3-1" "sdk-3.1";
  sdk-3-2 = mkPalmSdk "palm-os-sdk.sdk-3-2" "sdk-3.2";
  sdk-4 = mkPalmSdk "palm-os-sdk.sdk-4" "sdk-4";
  sdk-5r3 = mkPalmSdk "palm-os-sdk.sdk-5r3" "sdk-5r3";
  sdk-5r4 = mkPalmSdk "palm-os-sdk.sdk-5r4" "sdk-5r4";
  dana-2-0 = mkPalmSdk "palm-os-sdk.dana-2-0" "dana-2.0";
  handera-105 = mkPalmSdk "palm-os-sdk.handera-105" "handera-105";
}
