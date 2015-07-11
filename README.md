# DockerFile Qt5.4 NaCl

[![Join the chat at https://gitter.im/theshadowx/DockerFile_Qt5.4_NaCl](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/theshadowx/DockerFile_Qt5.4_NaCl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
DockerFile to generate a base image for ubuntu 14.04 with Qt5.4 and NaCl

## How to use 
In a termial go to the folder where have put Dockerfile.

Execute this command : 

  ```
  $  sudo docker build -t qtnacl5.4.2 .
  ```
It will take a lot of time !!!
Then execute this command to run a container :

  ```
  $  sudo docker run -i -t qtnacl5.4.2 /bin/bash
  ```
  
The NaCl SDK is in
  ```
  /opt/nacl_sdk/pepper_41
  ```
The Qt compiled with Nacl is in
  ```
  /opt/Qt_nacl/build/qtbase/bin
  ```
 
