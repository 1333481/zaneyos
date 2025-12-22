{ lib, fetchurl, appimageTools }:

let
  pname = "helium";
  # Pick a known Linux AppImage release; bump as needed.
  version = "0.6.2.1";
  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    sha256 = "1ngsxh4r7c4gmhxhimhwrr9bw8z8zdg02qw3vw3rkwbhbxxf0m7p";
  };
  contents = appimageTools.extractType2 { inherit pname version src; };

in appimageTools.wrapType2 {
  inherit pname version src;

  # AppImages usually bundle their libs, but add a few common ones just in case.
  extraPkgs = pkgs: with pkgs; [
    # graphics / input
    libglvnd libdrm libgbm
    libX11 libXcursor libXrender libXext libXtst libXi libXrandr libXScrnSaver
    libxkbcommon wayland
    # gtk stack
    glib gtk3
    # audio / printing / notifications
    alsa-lib libpulseaudio libnotify cups
    # nss
    nspr nss
    # tray icon support
    libappindicator-gtk3 at-spi2-atk at-spi2-core
  ];

  extraInstallCommands = ''
    # Try to install desktop file and icon from the AppImage, if present.
    if [ -f ${contents}/helium.desktop ]; then
      install -Dm444 ${contents}/helium.desktop $out/share/applications/helium.desktop
      substituteInPlace $out/share/applications/helium.desktop \
        --replace 'Exec=AppRun' 'Exec=helium'
    fi
    if [ -f ${contents}/helium.png ]; then
      install -Dm444 ${contents}/helium.png $out/share/icons/hicolor/512x512/apps/helium.png
    elif [ -f ${contents}/helium.svg ]; then
      install -Dm444 ${contents}/helium.svg $out/share/icons/hicolor/scalable/apps/helium.svg
    fi
  '';

  meta = with lib; {
    description = "Private, fast, and honest web browser (AppImage wrapped)";
    homepage = "https://helium.computer/";
    license = licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = [];
  };
}
