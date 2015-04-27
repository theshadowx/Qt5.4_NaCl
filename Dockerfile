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

#***************************
# Install NaCl SDK
#***************************
RUN wget http://storage.googleapis.com/nativeclient-mirror/nacl/nacl_sdk/nacl_sdk.zip
RUN unzip /opt/nacl_sdk.zip
RUN rm /opt/nacl_sdk.zip
WORKDIR /opt/nacl_sdk    
RUN /opt/nacl_sdk/naclsdk list
RUN /opt/nacl_sdk/naclsdk update pepper_41
RUN echo "export NACL_SDK_ROOT=/opt/nacl_sdk/pepper_41" >> /root/.bashrc
RUN /bin/bash -c "source /root/.bashrc"
ENV NACL_SDK_ROOT /opt/nacl_sdk/pepper_41

#***************************
# BUILD QT NACL
#***************************
WORKDIR /opt
RUN mkdir /opt/Qt_nacl
WORKDIR /opt/Qt_nacl
RUN git clone http://github.com/msorvig/qt5-qtbase-nacl.git
RUN git clone http://github.com/msorvig/qt5-qtdeclarative-nacl.git
RUN /opt/Qt_nacl/qt5-qtdeclarative-nacl/bin/rename-qtdeclarative-symbols.sh /opt/Qt_nacl/qt5-qtdeclarative-nacl
RUN git clone http://code.qt.io/cgit/qt/qt5.git Qt5.4.2
WORKDIR /opt/Qt_nacl/Qt5.4.2
RUN git checkout 5.4.2
RUN perl init-repository
RUN rm -r /opt/Qt_nacl/Qt5.4.2/qtbase
RUN rm -r /opt/Qt_nacl/Qt5.4.2/qtdeclarative
WORKDIR /opt/Qt_nacl/
RUN cp -r /opt/Qt_nacl/qt5-qtbase-nacl /opt/Qt_nacl/Qt5.4.2/qtbase
RUN cp -r /opt/Qt_nacl/qt5-qtdeclarative-nacl /opt/Qt_nacl/Qt5.4.2/qtdeclarative
RUN mkdir -v /opt/Qt_nacl/build
WORKDIR  /opt/Qt_nacl/build
RUN bash /opt/Qt_nacl/Qt5.4.2/qtbase/nacl-configure linux_x86_newlib release 64
RUN make module-qtbase -j6
RUN make module-qtdeclarative -j6
RUN make module-qtquickcontrols -j6
RUN rm -rf /opt/Qt_nacl/qt5-qtbase-nacl
RUN cp -r /opt/Qt_nacl/qt5-qtdeclarative-nacl/examples/ /opt/Qt_nacl/
RUN rm -rf /opt/Qt_nacl/qt5-qtdeclarative-nacl
WORKDIR /root
RUN echo "export PATH=\$PATH:/opt/Qt_nacl/build/qtbase/bin" >> /root/.bashrc
RUN echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/opt/Qt_nacl/build/qtbase/lib"  >> /root/.bashrc
RUN /bin/bash -c "source /root/.bashrc"
