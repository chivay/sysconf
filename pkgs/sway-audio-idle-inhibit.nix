{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, vala
, pkg-config
, wayland-protocols
, wayland
, libpulseaudio
}:
stdenv.mkDerivation rec
{
  pname = "sway-audio-idle-inhibit";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayAudioIdleInhibit";
    rev = "v${version}";
    hash = "sha256-XUUUUeaXO7GApwe5vA/zxBrR1iCKvkQ/PMGelNXapbA=";
  };

  buildInputs = [ meson ninja vala pkg-config wayland-protocols wayland libpulseaudio ];

  meta = with lib; {
    homepage = "https://github.com/ErikReider/SwayAudioIdleInhibit";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.chivay ];
  };
}
