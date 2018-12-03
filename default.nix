{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghcjs", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, containers, directory
      , filepath, HUnit, json, microlens-platform, optparse-applicative
      , stdenv, utf8-string
      }:
      mkDerivation {
        pname = "hasktags";
        version = "0.71.2";
        src = ./.;
        configureFlags = [ "-fembed-data-files" ];
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          base bytestring directory filepath json microlens-platform
          utf8-string
        ];
        executableHaskellDepends = [
          base containers directory filepath optparse-applicative
        ];
        testHaskellDepends = [
          base bytestring directory filepath HUnit json microlens-platform
          utf8-string
        ];
        homepage = "http://github.com/MarcWeber/hasktags";
        description = "Produces ctags \"tags\" and etags \"TAGS\" files for Haskell programs";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
