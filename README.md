# Qt5.4 NaCl
This repository contains dockerFile to make an image based on Ubuntu 14.04 and containing Qt5.4 compiled with Google Chrome Native Client (NaCl).

## Buiding the image from dockerFile
In a termial go to the folder where have put Dockerfile.

Execute this command : 

  ```
  $  docker build -t qtnacl5.4.2 .
  ```
It will take a lot of time !!!
Then execute this command to run a container :

  ```
  $  docker run -i -t qtnacl5.4.2 /bin/bash
  ```
  
The NaCl SDK is in

  ```
  /opt/nacl_sdk/pepper_(version)
  ```
  
The Qt compiled with Nacl is in

  ```
  /opt/QtNaCl5.4/
  ```
## Getting the image form Docker Hub
Instead of building yourself the image, it is automatically built each time the git repository is modified.

you can get the image by pulling it:

```
$ docker pull theshadowx/qt5.4-nacl
```

To use it, you'll need just to run a container:

```
$ docker run -it theshadowx/qt5.4-nacl
```
