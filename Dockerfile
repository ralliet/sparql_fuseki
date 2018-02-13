# Docker file for Sparql

# setup apache server
FROM ubuntu:16.04

# needed for last line
ADD install_sparql.sh home/install_sparql.sh
ADD shiro.ini.mac home/shiro.ini
RUN chmod u+x home/install_sparql.sh

# install all needed packages
RUN apt-get update
RUN apt-get install -y openjdk-8-jre
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y ruby

# install sparql
#RUN home/install_sparql.sh
