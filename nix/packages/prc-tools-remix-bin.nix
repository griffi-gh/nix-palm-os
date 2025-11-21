{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  ...
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "prc-tools-remix-bin";
  version = "2.3.5";

  src = fetchurl {
    url = "https://github.com/jichu4n/prc-tools-remix/releases/download/v${finalAttrs.version}/prc-tools-remix_${finalAttrs.version}.focal_amd64.deb";
    hash = "sha256-ojBv763HVQ1puSShfqSz6NV0V3O2srC1IPbNiRJpsiQ=";
  };

  nativeBuildInputs = [
    dpkg
  ];

  dontBuild = true;
  installPhase = ''
    mkdir -p $out
    mv usr/* $out
  '';

  passthru.build-prc = stdenvNoCC.mkDerivation {
    pname = "prc-tools-remix-bin.build-prc";
    inherit (finalAttrs)
      version
      src
      nativeBuildInputs
      ;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/{bin,share/man/man1}
      mv usr/bin/build-prc $out/bin
      mv usr/share/man/man1/build-prc.1 $out/share/man/man1
    '';

    meta = finalAttrs.meta // {
      description = finalAttrs.meta.description + " (build-prc only)";
    };
  };

  meta = {
    description = "prc-tools ported to modern Linux";
    homepage = "https://github.com/jichu4n/prc-tools-remix";
    platforms = lib.platforms.linux;
  };
})
