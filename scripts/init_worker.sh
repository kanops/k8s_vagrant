#!/bin/bash

JOIN_COMMAND=$(ssh -i /home/vagrant/.ssh/id_rsa -o "StrictHostKeyChecking=no" vagrant@192.168.50.11 "sudo kubeadm token create --print-join-command")
sudo $JOIN_COMMAND
rm /home/vagrant/.ssh/id_rsa