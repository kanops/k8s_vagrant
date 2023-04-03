#!/bin/bash

HOSTNAME=$(hostname)

if [[  "$HOSTNAME" = "control"*  ]] && [[  "$HOSTNAME" != "control-plane1"  ]];then
    echo "$HOSTNAME - JOIN CLUSTER"

    # Get join command
    JOIN_COMMAND=$(ssh -i /home/vagrant/.ssh/id_rsa -o "StrictHostKeyChecking=no" vagrant@192.168.50.11 "sudo echo \$(kubeadm token create --print-join-command) --control-plane --certificate-key \$(kubeadm init phase upload-certs --upload-certs | grep -vw -e certificate -e Namespace)")
    
    # Exec join command
    sudo $JOIN_COMMAND

    # Clean SSH
    rm /home/vagrant/.ssh/id_rsa
fi


if [[  "$HOSTNAME" = "control-plane1"  ]];then
    echo "$HOSTNAME - INIT FIRST CONTROL PLANE"
    kubeadm init --pod-network-cidr 192.168.0.0/16 \
    --apiserver-advertise-address "192.168.50.11" \
    --control-plane-endpoint "192.168.50.11"

    # Copy kubeconfig to user workspace
    mkdir -p /home/vagrant/.kube
    cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
    chown vagrant: /home/vagrant/.kube/config

    # Clean SSH
    rm /home/vagrant/.ssh/id_rsa
fi