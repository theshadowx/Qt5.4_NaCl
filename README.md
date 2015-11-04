# DockerFile Qt5.4 NaCl

[![Join the chat at https://gitter.im/theshadowx/DockerFile_Qt5.4_NaCl](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/theshadowx/DockerFile_Qt5.4_NaCl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
DockerFile to generate a base image for ubuntu 14.04 with Qt5.4 and NaCl

## Building dockerfile 
In a termial go to the folder where have put Dockerfile.

Execute this command : 

  ```bash
  $  sudo docker build -t qtnacl5.4.2 .
  ```
It will take a lot of time !!!
Then execute this command to run a container :

  ```bash
  $  sudo docker run -it qtnacl5.4.2 bash
  ```

## Using image from Docker Hub

Pull the image

```bash
$ docker pull theshadowx/qt5.4-nacl
```
  
Run a container

```bash
$ sudo docker run -it theshadowx/qt5.4-nacl bash
```

## How to build and deploy your application

So you have made your application and you want to build and deploy it using "QtNaCl", I think the best way is to mount the folder containing the project as a [Data Volume](http://docs.docker.com/engine/userguide/dockervolumes/) so that you could read/write data directly to the project folder.

**N.B. : you have to use the full path to "qmake and nacldeployqt" in order that some QML/Qt files would be generated, otherwise you will have a blank window in the browser when you deploy the application.**

### Generating Makefile

```bash
$ docker run --rm -it -v /path/to/ProjectFolder:/data/example theshadowx/qt5.4-nacl bash -c  "mkdir /data/example/build/ &&  /opt/QtNaCl_5.4/qtbase/bin/qmake /data/example -o /data/example/build/"
```

### Building

```bash
$ docker run --rm -it -v /path/to/ProjectFolder:/data/example theshadowx/qt5.4-nacl bash -c "cd /data/example/build && make"
```

### Deploying

```bash
$ docker run --rm -it -P -v /path/to/ProjectFolder:/data/example theshadowx/qt5.4-nacl:OoS_Qt5.4.2_NaCl42 bash -c "cd /data/example/build && /opt/QtNaCl_5.4/qtbase/bin/nacldeployqt ProjectName.bc --run"
```

Now the app is listening to port 8000

<pre>
Deploying "nacl.bc"
Using SDK "/opt/nacl_sdk/pepper_42"
Qt libs in "/opt/QtNaCl_5.4/qtbase/lib"
Output directory: "/data/example/build"
 
sh: 1: /usr/bin/google-chrome: not found
Serving HTTP on 0.0.0.0 port 8000 ...

</pre>

### Docker Ip

```bash
$ ifconfig
```
As result 


<pre>
docker0   Link encap:Ethernet  HWaddr 02:42:4c:f0:5b:e5  
          inet adr:<b>172.17.42.1</b>  Bcast:0.0.0.0  Masque:255.255.0.0
          adr inet6: fe80::42:4cff:fef0:5be5/64 Scope:Lien
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          Packets reçus:1267 erreurs:0 :0 overruns:0 frame:0
          TX packets:796 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 lg file transmission:0 
          Octets reçus:26991144 (26.9 MB) Octets transmis:68019 (68.0 KB)
</pre>

The IP : 172.17.42.1

### Container port

In another terminal :

``` bash
$ docker ps
```

| CONTAINER ID | IMAGE                 | COMMAND                | CREATED        | STATUS        | PORTS                   |
|--------------|-----------------------|------------------------|----------------|---------------|-------------------------|
| 834315034c8c | theshadowx/qt5.4-nacl | "bash -c 'cd /data/ex" | 24 seconds ago | Up 23 seconds | 0.0.0.0:**32772**->8000/tcp |

Here the port is 32772

### Chrome Browser

Open the chrome browser and put the following address (depending on the IP and the port you got from precedent steps)

```
http://172.17.42.1:32772
```

When you launch the app for the first time, you'll have to wait some seconds; But after that, it will be instantaneous.


## Location of Qt and NaCl SDK

The NaCl SDK is in
  ```
  /opt/nacl_sdk/pepper_42
  ```
The Qt compiled with NaCl is in
  ```
  /opt/QtNaCl_5.4
  ```
 
