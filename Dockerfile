FROM jhasse/android-ndk:r19c AS build
WORKDIR /tmp
RUN git clone https://code.qt.io/qt/qt5.git
WORKDIR /tmp/qt5
RUN perl init-repository
RUN git checkout v5.13.0
RUN git submodule update --recursive
RUN dnf install -y gcc-c++ python2 which
RUN ./configure -xplatform android-clang --disable-rpath -nomake tests -nomake examples -android-ndk $ANDROID_HOME/ndk-bundle -android-sdk $ANDROID_HOME -android-ndk-host linux-x86_64 -skip qttranslations -skip qtserialport -no-warnings-are-errors -opensource -confirm-license -no-widgets -skip qtwebglplugin -skip qtscxml -skip qtxmlpatterns -skip qtwebchannel -skip qtwebengine -skip qtscript -skip qtactiveqt -skip qtlocation -skip qtserialbus -skip qtserialport -skip qtgamepad -skip qtvirtualkeyboard -skip qtcanvas3d -skip qtcharts -skip qtdatavis3d -skip qt3d -skip qtpurchasing -skip qtwayland -skip qtremoteobjects -skip qtspeech -skip qtwebview -skip multimedia -skip qtquickcontrols
RUN make -j$(nproc) > /dev/null
RUN make install

FROM jhasse/android-ndk:r19c
COPY --from=build /usr/local/Qt-5.13.0 /opt/qt
RUN dnf install -y cmake && dnf clean all
