#!/bin/bash
set -exo # -e for error exit, -X for trace debug, -o for pipefail out
##Install Java
sudo apt update
sudo apt install openjdk-17-jdk -y
java -version
sleep 5

sudo apt install docker.io -y
sudo systemctl restart docker.service
sleep 5
sudo usermod -aG docker $USER
sudo apt-get update
sudo systemctl restart docker.service
