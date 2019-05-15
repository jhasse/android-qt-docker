FROM jhasse/android-ndk:r19b AS build
WORKDIR /tmp
RUN git clone https://code.qt.io/qt/qt5.git
WORKDIR /tmp/qt5
RUN perl init-repository
RUN git checkout v5.12.3
RUN git submodule update --recursive
RUN dnf install -y gcc-c++ python2 which
RUN ./configure -xplatform android-clang --disable-rpath -nomake tests -nomake examples -android-ndk $ANDROID_HOME/ndk-bundle -android-sdk $ANDROID_HOME -android-ndk-host linux-x86_64 -skip qttranslations -skip qtserialport -no-warnings-are-errors -opensource -confirm-license
RUN make -j$(nproc)
RUN make install

FROM jhasse/android-ndk:r19b
COPY --from=build /usr/local/Qt-5.12.3 /opt/Qt
