#!bin/bash

# Installation AZ CLI

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash


# Installation de kubectl

curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl

curl -LO https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256

echo "$(cat kubectl.sha256)  kubectl" | sha256sum –-check

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


# Installation de Kustomize v3.2.0

wget https://github.com/kubernetes-sigs/kustomize/releases/download/v3.2.0/kustomize_3.2.0_linux_amd64

sudo snap install kustomize