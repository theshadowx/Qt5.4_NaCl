FROM ubuntu:14.04
MAINTAINER Ali Diouri <alidiouri@gmail.com>

# install depdencies
RUN apt-get update          &&  \
    DEBIAN_FRONTEND=noninteractive apt-get -y upgrade      &&  \
    DEBIAN_FRONTEND=noninteractive apt-get install -y          \
        git                     \
        make                    \
        build-essential         \
        g++                     \
        lib32gcc1               \
        nano                    \
        libc6-i386              \
        python                  \
        python2.7               \
        unzip                   \
        wget                    \
        "^libxcb.*" \
        libx11-xcb-dev \
        libglu1-mesa-dev \
        libxrender-dev \
        libxi-dev \
        libssl-dev \
        libxcursor-dev \
        libxcomposite-dev \
        libxdamage-dev \
        libxrandr-dev \
        libfontconfig1-dev \
        libcap-dev \
        libbz2-dev \
        libgcrypt11-dev \
        libpci-dev \
        libnss3-dev \
        libxcursor-dev \
        libxcomposite-dev \
        libxdamage-dev \
        libxrandr-dev \
        libdrm-dev \
        libfontconfig1-dev \
        libxtst-dev \
        libasound2-dev \
        gperf \
        libcups2-dev \
        libpulse-dev \
        libudev-dev \
        libssl-dev \
        flex \
        bison \
        ruby \
        libicu-dev \
        libxslt-dev \
	zlib1g-dev

# Go to opt
WORKDIR /opt   

#******************************
#  get the script and apply it
#******************************
RUN wget http://storage.googleapis.com/nativeclient-mirror/nacl/nacl_sdk/nacl_sdk.zip
RUN unzip ./nacl_sdk.zip
RUN rm nacl_sdk.zip   
RUN nacl_sdk/naclsdk list

# get the latest stable bender
RUN nacl_sdk/naclsdk update pepper_42
ENV NACL_SDK_ROOT=/opt/nacl_sdk/pepper_42
 
WORKDIR /opt
 
# Checkout Qt 5.4
RUN git clone git://code.qt.io/qt/qt5.git Qt5.4_src
WORKDIR /opt/Qt5.4_src
RUN git checkout 5.4
RUN git submodule foreach 'git checkout 5.4'
RUN perl init-repository
WORKDIR /opt

# clone modules for NaCl 
RUN git clone https://github.com/msorvig/qt5-qtbase-nacl.git
WORKDIR /opt/qt5-qtbase-nacl
RUN git checkout nacl-5.4
WORKDIR /opt
RUN git clone https://github.com/msorvig/qt5-qtdeclarative-nacl.git
WORKDIR /opt/qt5-qtdeclarative-nacl
RUN bin/rename-qtdeclarative-symbols.sh  $PWD
WORKDIR /opt

# replace modules
RUN printf 'y' | rm -r /opt/Qt5.4_src/qtbase
RUN printf 'y' | rm -r /opt/Qt5.4_src/qtdeclarative
RUN cp -r qt5-qtbase-nacl /opt/Qt5.4_src/qtbase
RUN cp -r qt5-qtdeclarative-nacl /opt/Qt5.4_src/qtdeclarative

# apply patch
WORKDIR /opt
RUN wget https://raw.githubusercontent.com/theshadowx/Qt5.4_NaCl/fromScript/qtbase.patch
RUN wget https://raw.githubusercontent.com/theshadowx/Qt5.4_NaCl/fromScript/tools.patch
RUN wget https://raw.githubusercontent.com/theshadowx/Qt5.4_NaCl/fromScript/qtsvg.patch
WORKDIR /opt/Qt5.4_src/qtbase
RUN git apply /opt/qtbase.patch
WORKDIR /opt/Qt5.4_src/qtxmlpatterns
RUN git apply /opt/tools.patch
#WORKDIR /opt/Qt5.4_src/qtsvg
#RUN git apply /opt/qtsvg.patch

RUN mkdir /opt/QtNaCl_5.4

# Compile modules 
WORKDIR /opt/QtNaCl_5.4
RUN bash -c " NACL_SDK_ROOT=/opt/nacl_sdk/$(find /opt/nacl_sdk -maxdepth 1 -type d -printf "%f\n" | grep 'pepper')  /opt/Qt5.4_src/qtbase/nacl-configure linux_pnacl release 64 -v -release -nomake examples -nomake tests -nomake tools"

# Compiling modules
RUN make module-qtbase -j6
RUN make module-qtdeclarative -j6
RUN make module-qtquickcontrols -j6
RUN make module-qtmultimedia -j6
RUN make module-qtxmlpatterns -j6

# Adding Qt to the environement variables
ENV PATH=$PATH:/opt/QtNaCl_5.4/qtbase/bin:/opt/QtNaCl_5.4/qtbase/lib

# Cleaning
WORKDIR /opt/
RUN printf 'y' | rm -rf /opt/qt5-qtdeclarative-nacl
RUN printf 'y' | rm -rf /opt/qt5-qtbase-nacl

RUN rm /opt/qtbase.patch
RUN rm /opt/tools.patch
RUN rm /opt/qtsvg.patch

EXPOSE 8000
