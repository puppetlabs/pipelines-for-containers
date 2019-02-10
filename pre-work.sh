#!/bin/bash
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if [ -f "/usr/local/bin/brew" ]; then
  echo -e "${GREEN}Homebrew installation already detected, moving on.${NC}"
else
  open https://brew.sh/
  read -p "Press enter to continue after installing brew, the rest of the script will fail if homebrew is not installed."
fi

if [ -f "/usr/local/bin/kubectl" ]; then
  echo -e "${GREEN}Kubectl installation already detected, moving on.${NC}"
else
  echo "Installing kubectl"
  brew install kubernetes-cli
  KUBERNETES_VERSION=`kubectl version`
  echo -e "${YELLOW}Installed kubectl version $KUBERNETES_VERSION${NC}"
fi


if [ -f "/usr/local/bin/minikube" ]; then
  MINIKUBE_VERSION=`minikube version`
  echo -e "${GREEN} ${MINIKUBE_VERSION} already detected, moving on.${NC}"
else
  echo "Installing minikube"
  brew cask install minikube
  MINIKUBE_VERSION=`minikube version`
  echo -e "${YELLOW}Installed minikube version ${MINIKUBE_VERSION}${NC}"
fi

if [ -f "/usr/local/bin/docker" ]; then
  echo -e "${GREEN}Docker installation already detected, moving on.${NC}"
else
  open https://download.docker.com/mac/stable/Docker.dmg
  read -p "Press enter to continue after installing docker, Instructions for installing docker machine can be found here: https://docs.docker.com/docker-for-mac/install/#install-and-run-docker-for-mac"
fi


if [ -d "/Applications/VirtualBox.app" ]; then
  echo -e "${GREEN}VirtualBox installation already detected, moving on.${NC}"
else
  open https://www.virtualbox.org/wiki/Downloads
  read -p "Press enter to continue after installing virtualbox"
fi

if [ -f "/usr/local/bin/vagrant" ]; then
  echo -e "${GREEN}Vagrant installation already detected, moving on.${NC}"
else
  open https://www.vagrantup.com/downloads.html
  read -p "Press enter to continue after installing vagrant"
fi

echo "Installing Java"
brew cask install java
echo "Installing Maven"
brew install maven

echo "Starting minikube..."
minikube start --memory=4096

echo "Change to the assets directory, and run kubectl apply to start pfc."
echo "cd pipelines-for-containers/assets"
echo "kubectl apply -f pfc/"
