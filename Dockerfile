FROM ubuntu:14.04
MAINTAINER Ali Diouri <alidiouri@gmail.com>

# install depdencies
RUN apt-get update          &&  \
    apt-get -y upgrade      &&  \
    apt-get install -y          \
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
        wget                &&  \
    apt-get build-dep -y qt5-default && \
    apt-get install -y "^libxcb.*" \
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
        libxslt-dev

# Go to opt
WORKDIR /opt   


#******************************
#  get the script and apply it
#******************************
RUN wget https://raw.githubusercontent.com/theshadowx/DockerFile_Qt5.4_NaCl/fromScript/QtNaCl_docker.sh
RUN chmod +x QtNaCl_docker.sh
RUN sh QtNaCl_docker.sh
