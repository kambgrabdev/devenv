Vagrant.configure("2") do |config|

    config.vm.box = "centos/7"


    config.vm.provider "virtualbox" do |vb|
        vb.cpus = 2
        vb.memory = 2048
        vb.customize ["modifyvm", :id, "--vram", "128"]
        vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]  
        vb.gui = true
    end

    config.vm.define "master" do |node|
        node.vm.hostname = "master"
        node.vm.network "private_network", ip: "10.0.0.10"
        node.vm.provision "shell", path: "sh/init.sh"
        node.vm.network "forwarded_port", guest: 8001, host: 8001
    end

    (1..2).each do |i|
        config.vm.define "worker-#{i}" do |node|
            node.vm.hostname = "worker-#{i}"
            node.vm.network "private_network", ip: "10.0.0.10#{i}"
            node.vm.provision "shell", path: "sh/init.sh"
        
        end
    end
end