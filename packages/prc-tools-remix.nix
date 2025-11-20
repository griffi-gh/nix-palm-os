{
  lib,
  stdenv,
  fetchFromGitHub,
  flex,
  bison,
  texinfo,
  perl,
  ncurses,
  palm-os-sdk,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "prc-tools-remix";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "jichu4n";
    repo = "prc-tools-remix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C5zfPt082r968K88g99loDfvwWcr/6bK5JySkAhUXkA=";
  };

  nativeBuildInputs = [
    flex
    bison
    texinfo
    perl
  ];
  buildInputs = [
    ncurses
    stdenv.cc.libc
    palm-os-sdk
  ];

  AR = "${stdenv.cc.bintools.bintools}/bin/ar";
  RANLIB = "${stdenv.cc.bintools.bintools}/bin/ranlib";
  AR_FLAGS = "rcs";

  NIX_CFLAGS_COMPILE = [
    # upstream flags
    "-w"
    "-O2"
    "-fcommon"
    # extras :3
    "-std=gnu89"
    "-Wno-implicit-int"
    "-Wno-deprecated"
    "-Wno-error"
    "-fno-lto"
    "-fpermissive"
    "-I${stdenv.cc.libc}/include"
  ];

  patchPhase = ''
    runHook prePatch

    sed -i 's/^\([[:space:]]*\)m68k-palmos-coff\*)/\1m68k-palmos-coff* | m68k-*-palmos*)/' gcc-2.95.3/gcc/configure
    sed -i '/# include <config.h>/a #include <stdlib.h>' binutils-2.14/libiberty/regex.c

    runHook postPatch
  '';

  configurePhase = ''
    runHook preConfigure

    mkdir -p build
    cd build

    export MAKEINFO=true MAKEINFOFLAGS=
    ../prc-tools-2.3/configure \
      --prefix=$out \
      --with-palmdev-prefix=${palm-os-sdk} \
      --target=m68k-palmos \
      --host=i686-linux \
      --build=i686-linux \
      --enable-languages=c,c++ \
      --disable-nls \
      --disable-multilib \
      --disable-generic

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Build binutils first to produce nm-new.
    make -C binutils all

    # symlink m68k-palmos-nm which is needed for building GCC.
    mkdir -p $PWD/bin
    ln -s $PWD/binutils/binutils/nm-new $PWD/bin/m68k-palmos-nm
    export PATH=$PWD/bin:$PATH

    make AR=''${AR} RANLIB=''${RANLIB}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    make install PREFIX=$out prefix=$out

    runHook postInstall
  '';

  enableParallelBuilding = false;
  strictDeps = true;

  meta = with lib; {
    description = "GCC (2.95) m68k Palm OS cross-compilation toolchain (prc-tools remix)";
    homepage = "https://github.com/jichu4n/prc-tools-remix";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ ];
    broken = true; # TODO fix
  };
})
