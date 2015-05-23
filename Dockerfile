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
        wget                

# Go to opt
WORKDIR /opt   


#******************************
#  get the script and apply it
#******************************
RUN wget https://raw.githubusercontent.com/theshadowx/DockerFile_Qt5.4_NaCl/fromScript/QtNaCl_docker.sh
RUN chmod +x QtNaCl_docker.sh
RUN sh QtNaCl_docker.sh
