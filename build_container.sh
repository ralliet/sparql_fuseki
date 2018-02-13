#!/bin/bash

# Shell scrip to automatically build the docker container for 
# the https://github.com/lab9k/Skos repository. The container
# contains a ubuntu 16.04 server with Skosmos and an example
# vocabulary.
#
# WARNING: BE SURE TO RUN THIS SCRIPT IN THE FOLDER WITH THE
# SUPPLIED DOCKERFILE!

image_name="sparql:v1.1"
container_name="sparql"

# remove old container
echo "removing..."
sudo docker stop $container_name
sudo docker rm $container_name

# remove old image
sudo docker rmi $image_name
echo "DONE"

echo

echo "building..."
# build image
sudo docker build -t $image_name .

# build container
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='Darwin'
fi

if [[ $platform == 'linux' ]]; then
   echo "Using Linux platform command"
   sudo docker run -itd --network=host --name=$container_name $image_name
   sudo docker exec -d $container_name ./home/install_sparql.sh
elif [[ $platform == 'Darwin' ]]; then
   echo "Using Darwin platform command"
   sudo docker run -it -p 3030:3030 -d --name=$container_name $image_name
   sudo docker exec -d $container_name ./home/install_sparql.sh 1
fi
# attach to container with bash
#sudo docker exec -it $container_name bash

