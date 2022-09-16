{ lib
, stdenv
, fetchurl
, fetchpatch
, pkg-config
, libsndfile
, libtool
, makeWrapper
, perlPackages
, xorg
, libcap
, alsa-lib
, glib
, dconf
, avahi
, libjack2
, libasyncns
, lirc
, dbus
, sbc
, bluez5
, udev
, openssl
, fftwFloat
, soxr
, speexdsp
, systemd
, webrtc-audio-processing
, check
, meson
, ninja
, m4

, x11Support ? false

, useSystemd ? true

, # Whether to support the JACK sound system as a backend.
  jackaudioSupport ? false

, # Whether to build the OSS wrapper ("padsp").
  ossWrapper ? true

, airtunesSupport ? false

, bluetoothSupport ? true

, remoteControlSupport ? false

, zeroconfSupport ? false

, # Whether to build only the library.
  libOnly ? false

, AudioUnit
, Cocoa
, CoreServices
, ...
}:

stdenv.mkDerivation rec {
  pname = "${if libOnly then "lib" else ""}pulseaudio";
  version = "15.0";

  src = fetchurl {
    url = "http://freedesktop.org/software/pulseaudio/releases/pulseaudio-${version}.tar.xz";
    sha256 = "sha256-pAuIejupjMJpdusRvbZhOYjxRbGQJNG2VVxqA8nLoaA=";
  };

  patches = [
    ./add-option-for-installation-sysconfdir.patch
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config meson ninja makeWrapper perlPackages.perl perlPackages.XMLParser m4 ]
    ++ lib.optionals stdenv.isLinux [ glib ];

  propagatedBuildInputs =
    lib.optionals stdenv.isLinux [ libcap ];

  buildInputs =
    [ libtool libsndfile soxr speexdsp fftwFloat check ]
    ++ lib.optionals stdenv.isLinux [ glib dbus ]
    ++ lib.optionals stdenv.isDarwin [ AudioUnit Cocoa CoreServices ]
    ++ lib.optionals (!libOnly) (
      [ libasyncns webrtc-audio-processing ]
      ++ lib.optional jackaudioSupport libjack2
      ++ lib.optionals x11Support [ xorg.xlibsWrapper xorg.libXtst xorg.libXi ]
      ++ lib.optional useSystemd systemd
      ++ lib.optionals stdenv.isLinux [ alsa-lib udev ]
      ++ lib.optional airtunesSupport openssl
      ++ lib.optionals bluetoothSupport [ bluez5 sbc ]
      ++ lib.optional remoteControlSupport lirc
      ++ lib.optional zeroconfSupport avahi
    );

  mesonFlags = [
    "-Dalsa=${if !libOnly then "enabled" else "disabled"}"
    "-Dasyncns=${if !libOnly then "enabled" else "disabled"}"
    "-Davahi=${if zeroconfSupport then "enabled" else "disabled"}"
    "-Dbluez5=${if !libOnly then "enabled" else "disabled"}"
    "-Dbluez5-gstreamer=disabled"
    "-Ddatabase=simple"
    "-Ddoxygen=false"
    "-Delogind=disabled"
    "-Dgsettings=${if stdenv.buildPlatform == stdenv.hostPlatform then "enabled" else "disabled"}"
    "-Dgstreamer=disabled"
    "-Dgtk=disabled"
    "-Djack=${if jackaudioSupport && !libOnly then "enabled" else "disabled"}"
    "-Dlirc=${if remoteControlSupport then "enabled" else "disabled"}"
    "-Dopenssl=${if airtunesSupport then "enabled" else "disabled"}"
    "-Dorc=disabled"
    "-Dsystemd=${if useSystemd && !libOnly then "enabled" else "disabled"}"
    "-Dtcpwrap=disabled"
    "-Dudev=${if !libOnly then "enabled" else "disabled"}"
    "-Dvalgrind=disabled"
    "-Dwebrtc-aec=${if !libOnly then "enabled" else "disabled"}"
    "-Dx11=${if x11Support then "enabled" else "disabled"}"

    "-Dlocalstatedir=/var"
    "-Dsysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
    "-Dudevrulesdir=${placeholder "out"}/lib/udev/rules.d"
  ]
  ++ lib.optional (stdenv.isLinux && useSystemd) "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
  ;

  enableParallelBuilding = true;

  doCheck = true;
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = lib.optionalString libOnly ''
    rm -rf $out/{bin,share,etc,lib/{pulse-*,systemd}}
  ''
  + ''
    moveToOutput lib/cmake "$dev"
    rm -f $out/bin/qpaeq # this is packaged by the "qpaeq" package now, because of missing deps
  '';

  preFixup = lib.optionalString (stdenv.isLinux && (stdenv.hostPlatform == stdenv.buildPlatform)) ''
    wrapProgram $out/libexec/pulse/gsettings-helper \
     --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/${pname}-${version}" \
     --prefix GIO_EXTRA_MODULES : "${lib.getLib dconf}/lib/gio/modules"
  '';

  passthru = {
    pulseDir = "lib/pulse-" + lib.versions.majorMinor version;
  };

  meta = {
    description = "Sound server for POSIX and Win32 systems";
    homepage = "http://www.pulseaudio.org/";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ lovek323 ];
    platforms = lib.platforms.unix;

    longDescription = ''
      PulseAudio is a sound server for POSIX and Win32 systems.  A
      sound server is basically a proxy for your sound applications.
      It allows you to do advanced operations on your sound data as it
      passes between your application and your hardware.  Things like
      transferring the audio to a different machine, changing the
      sample format or channel count and mixing several sounds into
      one are easily achieved using a sound server.
    '';
  };
}
