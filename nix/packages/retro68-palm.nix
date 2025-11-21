{
  lib,
  stdenv,
  newScope,
  symlinkJoin,
  wrapBintoolsWith,
  wrapCCWith,
  fetchFromGitHub,
  fetchpatch,
  applyPatches,
  texinfo,
  gmp,
  mpfr,
  libmpc,
}:
let
  srcPatched = applyPatches {
    src = fetchFromGitHub {
      owner = "autc04";
      repo = "Retro68";
      rev = "83b9c8d2c58f8efb0925a305aca1e0edab2e6571";
      hash = "sha256-CHBa4KBtVZIrpTPWsEhFzaXQnnIQLYnYNzpsXeFe0TY=";
    };
    patches = [
      # patches originally created by Dmitry Grinberg (https://dmitry.gr/)
      (fetchpatch {
        url = "https://github.com/griffi-gh/Retro68-palm/commit/812f86d3c0c572877e6e7ffcca31eeb6f7725a50.patch";
        hash = "sha256-xjwsPqzOSS/CDUJzHaTK8spOBouUEcqlhptXm4krYkI=";
      })
    ];
  };
in
lib.makeScope newScope (self: {
  # based on https://github.com/griffi-gh/Retro68-palm/blob/c84dd7b02b5cddeec189fc225b74ec81c05804a6/nix/overlay.nix

  binutils_unwrapped = stdenv.mkDerivation {
    pname = "retro68-palm.binutils_unwrapped";
    version = "0-unstable-83b9c8d2c58f8efb0925a305aca1e0edab2e6571";

    src = "${srcPatched}/binutils";

    buildInputs = [ texinfo ];

    configureFlags = [
      "--target=m68k-none-elf"
      "--disable-doc"
    ];
    enableParallelBuilding = true;

    postInstall =
      let
        ld = "$out/bin/m68k-none-elf-ld";
        ld_real = "$out/bin/m68k-none-elf-ld.real";
      in
      ''
        mv ${ld} ${ld_real}

        echo "#!${stdenv.shell}" > ${ld}
        echo "exec \$''
      + ''
        {RETRO68_LD_WRAPPER_Retro68-${ld_real}} \"\$@\"" >> ${ld}
        chmod +x ${ld}

        rm $out/m68k-none-elf/bin/ld
        ln -s ${ld} $out/m68k-none-elf/bin/ld
      '';
  };

  gcc_unwrapped = stdenv.mkDerivation rec {
    pname = "retro68-palm.gcc_unwrapped";
    version = "0-unstable-83b9c8d2c58f8efb0925a305aca1e0edab2e6571";

    src = "${srcPatched}/gcc";
    buildInputs = [
      self.binutils_unwrapped
      gmp
      mpfr
      libmpc
    ];
    configureFlags = [
      "--target=m68k-none-elf"
      # "--enable-languages=c,c++"
      "--enable-languages=c"
      "--disable-libssp"
      "MAKEINFO=missing"
      "--disable-multilib"
      # stdenv.targetPlatform.retro68GccConfig
      "--with-arch=m68k"
      "--with-cpu=m68000"
    ];
    hardeningDisable = [ "format" ];
    enableParallelBuilding = true;

    # nix does in-source builds by default, and something breaks
    buildCommand = ''
      mkdir -p $out/m68k-none-elf/bin
      ln -s ${self.binutils_unwrapped}/m68k-none-elf/bin/* $out/m68k-none-elf/bin/

      export target_configargs="--disable-nls --enable-libstdcxx-dual-abi=no --disable-libstdcxx-verbose"
      $src/configure ${builtins.toString configureFlags} --prefix=$out
      make -j$NIX_BUILD_CORES || make
      make install
    '';
  };

  binutils = wrapBintoolsWith {
    name = "retro68-palm.binutils";
    bintools = self.binutils_unwrapped;
    libc = null;
  };

  gcc = self.gcc_unwrapped;
  # XXX: wrapped package produces empty bin dir, todo investigate
  # gcc = wrapCCWith {
  #   name = "retro68-palm.gcc";
  #   cc = self.gcc_unwrapped;
  #   bintools = self.binutils;
  #   libc = null;
  #   extraBuildCommands = ''
  #     echo "" > $out/nix-support/add-hardening.sh
  #   '';
  # };

  toolchain_combined = symlinkJoin {
    name = "retro68-palm.toolchain_combined";
    paths = [
      self.binutils_unwrapped
      self.gcc_unwrapped
    ];
  };
})
