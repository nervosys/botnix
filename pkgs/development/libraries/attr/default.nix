{ lib, stdenv, fetchurl, gettext }:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Botpkgs as
# files.

stdenv.mkDerivation rec {
  pname = "attr";
  version = "2.5.1";

  src = fetchurl {
    url = "mirror://savannah/attr/${pname}-${version}.tar.gz";
    sha256 = "1y6sibbkrcjygv8naadnsg6xmsqwfh6cwrqk01l0v2i5kfacdqds";
  };

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ gettext ];

  postPatch = ''
    for script in install-sh include/install-sh; do
      patchShebangs $script
    done
  '';

  meta = with lib; {
    homepage = "https://savannah.nongnu.org/projects/attr/";
    description = "Library and tools for manipulating extended attributes";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
