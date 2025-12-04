{
  lib,
  multiStdenv,
  fetchzip,
  stdenvNoCC,
  ...
}:
multiStdenv.mkDerivation (finalAttrs: {
  pname = "pilrc";
  version = "3.3.0-unofficial";

  src = fetchzip {
    pname = "pilrc-src";
    version = "3.2.0"; # 3.2.90 is latest official release, but 3.3.0-unofficial only applies to 3.2.0
    url = "https://master.dl.sourceforge.net/project/pilrc/pilrc/3.2/pilrc-3.2.tar.gz";
    hash = "sha256-G/vkOb4Co9lzOYh2bXBB5Wcf0oSio8Om/tQ8A4ItylU=";
  };

  patches = [
    (stdenvNoCC.mkDerivation {
      name = "pilrc-patches";
      # 3.3.0-unofficial patchset by Dmitry Grinberg
      src = fetchzip {
        url = "https://drive.usercontent.google.com/download?id=1Ssvmazc9Hb5KOD7_5psjwx-DRmi0zQqp&authuser=0";
        hash = "sha256-2AM30ejLaL9Xpcz9oI7fhKTS+1rIQexq1KkyE4iWnvQ=";
        extension = "zip";
        stripRoot = false;
      };
      installPhase = ''
        cat *.patch > $out
      '';
    })
  ];

  postPatch = ''
    substituteInPlace 'version.h' \
      --replace-fail '3, 2, 0, 0' '3, 3, 0, 0' \
      --replace-fail '"3.2"' '"${finalAttrs.version}"'
  '';

  configureScript = "unix/configure";
  env.NIX_CFLAGS_COMPILE = "-m32 -Wno-error=incompatible-pointer-types";

  meta = {
    description = "Palm OS resource compiler (3.3.0 unofficial)";
    homepage = "https://github.com/jichu4n/pilrc";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
})
