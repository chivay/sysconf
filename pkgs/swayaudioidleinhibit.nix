{ lib
, stdenv
, meson
, cmake
, ninja
, pkg-config
, scdoc
, wayland-scanner
, wayland-protocols
, fetchFromGitHub
, wayland
, libxkbcommon
, cairo
, gdk-pixbuf
, pam
, libpulseaudio
, ...
}:

stdenv.mkDerivation rec {
  pname = "swayaudioidleinhibit";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayAudioIdleInhibit";
    rev = "v${version}";
    sha256 = "sha256-XUUUUeaXO7GApwe5vA/zxBrR1iCKvkQ/PMGelNXapbA=";
  };

  #postPatch = ''
  #  substituteInPlace meson.build \
  #    --replace "version: '1.4'" "version: '${version}'"
  #'';

  nativeBuildInputs = [ meson ninja cmake pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland wayland-protocols cairo libxkbcommon cairo gdk-pixbuf pam libpulseaudio ];

  #mesonFlags = [
  #  "-Dpam=enabled" "-Dgdk-pixbuf=enabled" "-Dman-pages=enabled"
  #];

  meta = with lib; {
    description = "Audio idle inhibitor for sway";
    longDescription = ''
    '';
    inherit (src.meta) homepage;
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ chivay ];
  };
}
