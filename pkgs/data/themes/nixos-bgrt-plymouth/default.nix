{ lib
, stdenv
, fetchFromGitHub
, unstableGitUpdater
}:

stdenv.mkDerivation {
  name = "botnix-bgrt-plymouth";
  version = "unstable-2023-03-10";

  src = fetchFromGitHub {
    repo = "plymouth-theme-botnix-bgrt";
    owner = "helsinki-systems";
    rev = "0771e04f13b6b908d815b506472afb1c9a2c81ae";
    hash = "sha256-aF4Ro5z4G6LS40ENwFDH8CgV7ldfhzqekuSph/DMQoo=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes/botnix-bgrt
    cp -r $src/{*.plymouth,images} $out/share/plymouth/themes/botnix-bgrt/
    substituteInPlace $out/share/plymouth/themes/botnix-bgrt/*.plymouth --replace '@IMAGES@' "$out/share/plymouth/themes/botnix-bgrt/images"

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "BGRT theme with a spinning Botnix logo";
    homepage = "https://github.com/helsinki-systems/plymouth-theme-botnix-bgrt";
    license = licenses.mit;
    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = platforms.all;
  };
}
