{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      legacyPackages = {
        # package sets
        palm-os-sdk = pkgs.callPackages ./palm-os-sdk.nix { };
        retro68-palm = pkgs.callPackages ./retro68-palm.nix { };
        prc-tools-remix-bin = pkgs.callPackage ./prc-tools-remix-bin.nix { };
      };
    };
}
