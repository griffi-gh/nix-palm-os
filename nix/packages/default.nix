{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      legacyPackages = {
        palm-os-sdk = pkgs.callPackages ./palm-os-sdk.nix { };
        retro68-palm = pkgs.callPackages ./retro68-palm.nix { };
        pilrc = pkgs.callPackage ./pilrc32.nix { };
        pilrc33 = pkgs.callPackage ./pilrc33.nix { };
        prc-tools-remix-bin = pkgs.callPackage ./prc-tools-remix-bin.nix { };
      };
    };
}
