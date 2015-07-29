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
git clone git://code.qt.io/qt/qt5.git Qt5.4.2_src
cd Qt5.4.2_src
git checkout 5.4.2
perl init-repository
cd ..

# clone modules for NaCl 
git clone https://github.com/msorvig/qt5-qtbase-nacl.git
git clone https://github.com/msorvig/qt5-qtdeclarative-nacl.git
cd qt5-qtdeclarative-nacl
sh bin/rename-qtdeclarative-symbols.sh  $PWD
cd ..

# replace modules
printf 'y' | rm -r Qt5.4.2_src/qtbase
printf 'y' | rm -r Qt5.4.2_src/qtdeclarative
cp -r qt5-qtbase-nacl Qt5.4.2_src/qtbase
cp -r qt5-qtdeclarative-nacl Qt5.4.2_src/qtdeclarative

# apply patch
wget https://raw.githubusercontent.com/theshadowx/Qt5.4_NaCl/fromScript/qtbase.patch
cd Qt5.4.2_src/qtbase
git apply ../../qtbase.patch
cd ../..
wget https://raw.githubusercontent.com/theshadowx/Qt5.4_NaCl/fromScript/tools.patch
cd Qt5.4.2_src/qttools
git apply ../../tools.patch
cd ../..

# Compile modules 
mkdir build
cd build 
bash /opt/Qt5.4.2_src/qtbase/nacl-configure linux_x86_newlib release 64 --prefix=/opt/QtNaCl_5.4
make module-qtbase -j6
make module-qtdeclarative -j6
make module-qtquickcontrols -j6
make module-qtmultimedia -j6
make module-qtxmlpatterns -j6
make install

echo "export PATH=$PATH:/opt/QtNaCl_5.4/bin" >> ~/.bashrc
source ~/.bashrc

cd /opt
wget https://raw.githubusercontent.com/theshadowx/Qt5.4_NaCl/fromScript/compilenacl.sh
chmod +x compilenacl.sh
mv compilenacl.sh /usr/bin/compilenacl

# Cleaning
printf 'y' | rm -r qt5-qtdeclarative-nacl
printf 'y' | rm -r qt5-qtbase-nacl
#printf 'y' | rm -r Qt5.4.2_src
rm qtbase.patch
rm tools.patch
rm QtNaCl_docker.sh
