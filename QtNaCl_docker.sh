#!/bin/bash
 
# Install NaCl
wget http://storage.googleapis.com/nativeclient-mirror/nacl/nacl_sdk/nacl_sdk.zip
unzip nacl_sdk.zip
rm nacl_sdk.zip   
nacl_sdk/naclsdk list
# get the latest stable bender
nacl_sdk/naclsdk update
pepperDir=$(find ./nacl_sdk -maxdepth 1 -type d -printf "%f\n" | grep 'pepper')
echo "export NACL_SDK_ROOT=$PWD/nacl_sdk/${pepperDir}" >> ~/.bashrc
bash -c "source ~/.bashrc"
export NACL_SDK_ROOT=$PWD/nacl_sdk/${pepperDir}
echo $NACL_SDK_ROOT
 
# Checkout Qt 5.4.2
git clone git://code.qt.io/qt/qt5.git Qt5.4.2
cd Qt5.4.2
git checkout 5.4.2
perl init-repository
cd ..
 
git clone https://github.com/msorvig/qt5-qtbase-nacl.git
git clone https://github.com/msorvig/qt5-qtdeclarative-nacl.git
cd qt5-qtdeclarative-nacl
sh bin/rename-qtdeclarative-symbols.sh  $PWD
cd ..
 
printf 'y' | rm -r Qt5.4.2/qtbase
printf 'y' | rm -r Qt5.4.2/qtdeclarative
cp -r qt5-qtbase-nacl Qt5.4.2/qtbase
cp -r qt5-qtdeclarative-nacl Qt5.4.2/qtdeclarative
 
mkdir QtNacl_5.4
cd QtNacl_5.4
bash ../Qt5.4.2/qtbase/nacl-configure linux_x86_newlib release 64
make module-qtbase -j6
make module-qtdeclarative -j6
make module-qtquickcontrols -j6

echo "export PATH=$PATH:$PWD/qtbase/bin" >> ~/.bashrc
source ~/.bashrc

# go back to /opt
cd .. 
git clone https://gist.github.com/8357a17d6839acd53105.git
mv 8357a17d6839acd53105/compile.sh .
printf 'y' | rm -r 8357a17d6839acd53105
chmod +x compile.sh
ln -s compile.sh compile
mv compile /usr/bin

# Cleaning
printf 'y' | rm -r qt5-qtdeclarative-nacl
printf 'y' | rm -r qt5-qtbase-nacl
#printf 'y' | rm -r Qt5.4.2
