# TODO
{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pilrc";
  version = "3.2.90";

  src = fetchFromGitHub {
    owner = "jichu4n";
    repo = "pilrc";
    rev = "55f104a4859c9bed1b768645cba1b21dbef226c3";
    hash = "sha256-Ns6ZXu7lVJ4CM0CFC4PJvaUuo4JpDKcRbGEzkkAt1TQ=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  sourceRoot = "${finalAttrs.src.name}/unix";

  meta = {
    description = "Palm OS resource compiler (3.2.x)";
    homepage = "https://github.com/jichu4n/pilrc";
    license = lib.licenses.gpl2Only;
  };
})
