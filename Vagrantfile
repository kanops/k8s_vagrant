NMB_CONTROL_PLANE = 1
NMB_WORKER = 2
IMAGE= "bento/ubuntu-20.04"


Vagrant.configure("2") do |config|
  # Provider
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  # Control plane
  (1..NMB_CONTROL_PLANE).each do |i|
    config.vm.define "control-plane#{i}" do |control_plane|
      control_plane.vm.box = IMAGE
      control_plane.vm.hostname = "control-plane#{i}"
      control_plane.vm.network "private_network", ip: "192.168.50.#{i+10}"
      control_plane.vm.provision "file", source: "./.ssh/id_rsa.pub", destination: "/tmp/id_rsa.pub"
      control_plane.vm.provision "file", source: "./.ssh/id_rsa", destination: "/tmp/id_rsa"
      control_plane.vm.provision "shell", privileged: true, path: "scripts/init_k8s.sh"
      control_plane.vm.provision "shell", privileged: true, path: "scripts/init_master.sh"
    end
  end

  # Worker
  (1..NMB_WORKER).each do |i|
    config.vm.define "worker#{i}" do |kubenodes|
      kubenodes.vm.box = IMAGE
      kubenodes.vm.hostname = "worker#{i}"
      kubenodes.vm.network "private_network", ip: "192.168.50.#{i+20}"
      kubenodes.vm.provision "file", source: "./.ssh/id_rsa.pub", destination: "/tmp/id_rsa.pub"
      kubenodes.vm.provision "file", source: "./.ssh/id_rsa", destination: "/tmp/id_rsa"
      kubenodes.vm.provision "shell", privileged: true,  path: "scripts/init_k8s.sh"
      kubenodes.vm.provision "shell", path: "scripts/init_worker.sh"
    end
  end
end
