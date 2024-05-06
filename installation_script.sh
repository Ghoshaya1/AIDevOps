#!/bin/bash

# Detect the operating system
OS=$(uname -s)

# Function to install VirtualBox
install_virtualbox() {
    if [[ "$OS" == "Darwin" ]]; then
        # For macOS
        echo "Installing VirtualBox for macOS..."
        brew install virtualbox
    elif [[ "$OS" == "Linux" ]]; then
        # For Ubuntu
        echo "Installing VirtualBox for Ubuntu..."
        sudo apt-get update
        sudo apt-get install -y virtualbox
    else
        echo "Unsupported operating system"
        exit 1
    fi
}

# Function to install Docker
install_docker() {
    if [[ "$OS" == "Darwin" ]]; then
        # For macOS
        echo "Installing Docker for macOS..."
        brew install docker
    elif [[ "$OS" == "Linux" ]]; then
        # For Ubuntu
        echo "Installing Docker for Ubuntu..."
        sudo apt-get update
        sudo apt-get install -y docker.io
        sudo usermod -aG docker $USER
        newgrp docker
    else
        echo "Unsupported operating system"
        exit 1
    fi
}

# Function to install Minikube
install_minikube() {
    echo "Installing Minikube..."
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
}

# Function to install kubectl
install_kubectl() {
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
}

# Check if VirtualBox is installed
if ! command -v VBoxManage &> /dev/null; then
    install_virtualbox &
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    install_docker &
fi

# Check if Minikube is installed
if ! command -v minikube &> /dev/null; then
    install_minikube &
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    install_kubectl &
fi

# Wait for VirtualBox installation to complete
while ! command -v VBoxManage &> /dev/null; do
    echo "Waiting for VirtualBox installation to complete..."
    sleep 5
done

echo "VirtualBox is installed."

# Wait for Docker installation to complete
while ! command -v docker &> /dev/null; do
    echo "Waiting for Docker installation to complete..."
    sleep 5
done

echo "Docker is installed."

# Wait for Minikube installation to complete
while ! command -v minikube &> /dev/null; do
    echo "Waiting for Minikube installation to complete..."
    sleep 5
done

echo "Minikube is installed."

# Wait for kubectl installation to complete
while ! command -v kubectl &> /dev/null; do
    echo "Waiting for kubectl installation to complete..."
    sleep 5
done

echo "kubectl is installed."

# Install Minikube addons
echo "Installing Minikube addons..."
minikube addons enable ingress

# Start the Minikube cluster with multiple nodes
echo "Starting Minikube cluster with 3 nodes in separate VMs..."
minikube start --nodes 3 --vm-driver=virtualbox  # Use appropriate VM driver for your system

# Wait for Minikube to be ready
echo "Waiting for Minikube to start..."
until minikube status &> /dev/null
do
    echo "Minikube is not yet ready. Sleeping for 10 seconds..."
    sleep 10
done

echo "Minikube cluster is up and running with 3 nodes in separate VMs!"

# Install Helm and update
echo "Installing Helm..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

echo "Updating Helm repositories..."
helm repo update

echo "Helm is installed and repositories are updated!"

# Execute req.sh script and capture output
echo "Executing req.sh script..."
req_output=$(./dep.sh 2>&1)

# Check the exit status of dep.sh
if [ $? -ne 0 ]; then
    echo "req.sh script encountered errors:"
    echo "$req_output"
else
    echo "Requirement installation is completed."
fi
