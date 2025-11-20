{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };
  outputs =
    inputs@{
      flake-parts,
      systems,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      perSystem =
        { pkgs, ... }:
        {
          packages = rec {
            palm-os-sdk = {
              PalmOne = pkgs.callPackage ./packages/palm-os-sdk.nix {
                pname = "palm-os-sdk-PalmOne";
                sdkDir = "sdk-PalmOne";
              };
              sdk-1 = pkgs.callPackage ./packages/palm-os-sdk.nix {
                pname = "palm-os-sdk-1";
                sdkDir = "sdk-1";
              };
              sdk-2 = pkgs.callPackage ./packages/palm-os-sdk.nix {
                pname = "palm-os-sdk-2";
                sdkDir = "sdk-2";
              };
              sdk-3-1 = pkgs.callPackage ./packages/palm-os-sdk.nix {
                pname = "palm-os-sdk-3-1";
                sdkDir = "sdk-3.1";
              };
              sdk-3-2 = pkgs.callPackage ./packages/palm-os-sdk.nix {
                pname = "palm-os-sdk-3-2";
                sdkDir = "sdk-3.2";
              };
              sdk-4 = pkgs.callPackage ./packages/palm-os-sdk.nix {
                pname = "palm-os-sdk-4";
                sdkDir = "sdk-4";
              };
              sdk-5r3 = pkgs.callPackage ./packages/palm-os-sdk.nix {
                pname = "palm-os-sdk-5r3";
                sdkDir = "sdk-5r3";
              };
              sdk-5r4 = pkgs.callPackage ./packages/palm-os-sdk.nix {
                pname = "palm-os-sdk-5r4";
                sdkDir = "sdk-5r4";
              };
              dana-2-0 = pkgs.callPackage ./packages/palm-os-sdk.nix {
                pname = "palm-os-sdk-dana-20";
                sdkDir = "dana-2.0";
              };
              handera-105 = pkgs.callPackage ./packages/palm-os-sdk.nix {
                pname = "palm-os-sdk-handera-105";
                sdkDir = "handera-105";
              };
            };

            # (currently broken)
            prc-tools-remix = pkgs.pkgsi686Linux.callPackage ./packages/prc-tools-remix.nix {
              palm-os-sdk = palm-os-sdk.sdk-4;
            };
          };
          formatter = pkgs.nixfmt-tree;
        };
    };
}
