#!/bin/bash

KUBE_VERSION="1.26.3-00"

# Deploy keys to allow all nodes to connect each others as vagrant
mv /tmp/id_rsa*  /home/vagrant/.ssh/

chmod 400 /home/vagrant/.ssh/id_rsa*
chown vagrant:  /home/vagrant/.ssh/id_rsa*

cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
chmod 400 /home/vagrant/.ssh/authorized_keys
chown vagrant: /home/vagrant/.ssh/authorized_keys

# Enable modules for docker
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Enable networking config for k8s
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

# Install docker
apt-get update && sudo apt-get install -y docker.io

# Disable swap
usermod -aG docker vagrant
swapoff -a

# Install dependy packages
apt-get update && sudo apt-get install -y apt-transport-https curl

# Add k8s GPG key
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

# Add repository list
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

# Install k8s
apt-get update && apt-get install -y kubelet=$KUBE_VERSION kubeadm=$KUBE_VERSION kubectl=$KUBE_VERSION

# Disable auto-update
apt-mark hold kubelet kubeadm kubectl

