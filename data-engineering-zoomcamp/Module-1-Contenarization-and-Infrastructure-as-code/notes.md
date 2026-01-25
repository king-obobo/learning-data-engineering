# Concepts, Theory and Notes.
## Docker.
**What is Docker ?**: Docker is a virtualization software that makes developing and deploying apps much easier. It does this by packaging applications with all the necessary dependencies, configuration, system tools and run time. It is a standardized unit that has everything an application needs to run.


### Operating Systems, Layers, Virtual Machines and Docker.

There are 2 layers to the Operating system. 
* The OS application layer: Apps and softwares on top of the kernel
* The OS kernel: Communicates with the hardware 


Docker virtualizes the OS application layer while using the kernel of the host. This is in contrast to Virtual Machines that virtualizes the complete OS (application layer + Kernel).


## Setting Up Docker on your PC.
I personally had to install a virtual machine, then install Ubuntu LTS before I installed docker. You can follow the video below to install oracles virtual machine on your windows if you use a windows machine and then follow dockers documentatio to install docker on your linux machine.
* [Guide to installing a VM](https://www.youtube.com/watch?v=CY0fyw5Fogg)
* [Guide to installing docker on Linux](https://docs.docker.com/engine/install/ubuntu/)

## Images and Containers
A Docker image is an executable application artifact. It includes app source codes and complete environments configurations.

A container on the other hand is simply a running instance of an image. You can run multiple containers from an image and you can only get a container after downloading and running an image.

### Commands
- `docker images` lists all running images

- `docker ps` lists all running containers

- `docker ps -a` lists all containers, running or not

## Docker registry
We get containers by running images. In essence, we run images in a container. Where then do we get images from ? We get most of them from a registry. Docker has an official registry called **"Docker Hub"** for the storage and distribution of docker images. Docker hub also happens to be the default location for downloading images from.

## Image Versioning
Docker images are versioned. Different versions are identified by their tags. If you do not explicitly choose a tag, you get the latest version of the image from the registry. Using a specific version can often be important.

## Pulling Images
We use the command below to pull an image from docker hub

`docker pull name_of_image:image_tag`

e.g

`docker pull python:3.13.11-slim`

## Running an Image
To run an image, use the command below:

`docker run image_name:tag`

The `docker pull` command is no longer used as much as the `docker run` commands abstracts away the `docker pull` command. 

When you run the `docker run` command, it first looks for the image locally. If it does not find the image locally, it pulls that image from the registry before running the image in a container.
Running the `docker run` command also brings the logs to the foreground requiring you to open up another terminal to run other commands.
To start a container in the background using the `docker run` command, you can add the -d tag to the command. This detaches the process.
`docker run -d nginx:123`

Docker also randomly generates a name for the container if you do not specify one. To specify one, you can add the `--name` tag.

## Binding Ports
When apps are run inside containers, they are in isolated  docker networks and cannot communicate outside of this isolated network unless explicitly exposed. We must expose our container to the host via port binding as containers run on specific ports.
To bind or map a port you can add the -p flag to the docker run command. 

E.g
```
docker run -p host_port:container_port image_name:image_tag
```
To be more specific 
```
docker run -p 9000:80 nginx:1.23
```


The standard is often to use the same port on your host as your container.
```
docker run -p 80:80 nginx:1.23
```
The port the container is running on can be obtained from the image profile via the docker registry


## Starting and Stopping a container
`docker run` command creates a new container each time it is ran.


`docker ps -a` lists all containers, running or not.

To stop an already running container, run the command below:
```
docker stop docker_id
```
OR
```
docker stop container_name
```


## Docker Registries
Docker registries may be
* Public (eg Docker hub)
* Private 


## Creating you Images (via Dockerfile)
For us to create our own image, we must always create a definition of how to build an image from our application. This definition is written in a dockerfile. Docker can then build the image by reading the instructions in the file.


Docker files start from a parent image or base image. This is a docker image that your image is based on.
* Dockerfiles must begin with a `FROM` instruction
* Every image consists of multiple image layers
* This makes docker so efficient because image layers can be cached
* The `RUN` command executes the commands in a shell inside the container 
* The `COPY` command copies files or does from the source and adds them to the file system of the container at a path 
* The `WORKDIR` sets the working directory for all the following commands 
* The `CMD` command tells the docker what to be executed when the container starts. E.g `CMD [“node”, “server.js”]`
* The `BUILD` command builds the image following the instructions from the Dockerfile. `docker build -t node-app:1.0 .`




Say you want to set up an image and access it via an entry point, you can run
```
docker run -it –entrypoint=bash –rm test:panda
```


Volumes in docker.
Volumes are used to persist data in containers

