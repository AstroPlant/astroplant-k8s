with import <nixpkgs> { };
let
  mo = { lib, stdenv, fetchurl }:
    stdenv.mkDerivation rec {
      pname = "mo";
      version = "2.1.0";

      src = fetchurl {
        url =
          "https://github.com/tests-always-included/mo/archive/${version}.tar.gz";
        sha256 = "1parnmxxmirgfym2zzjk8h32ch3i20gwraxgf18ilw4p0wvawy0i";
      };

      installPhase = ''
        mkdir -p $out/bin
        mv mo $out/bin/mo
      '';

      meta = with lib; {
        description = "Mustache templates in pure bash.";
        homepage = "https://github.com/tests-always-included/mo";
        license = licenses.mit;
        maintainers = [ ];
        platforms = [ "x86_64-linux" ];
      };
    };
in pkgs.mkShell {
  buildInputs = with pkgs; [ kubectl (callPackage mo { }) cowsay ];
}
