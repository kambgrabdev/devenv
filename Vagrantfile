Vagrant.configure("2") do |config|

    config.vm.box = "centos/7"


    config.vm.provider "virtualbox" do |vb|
        vb.cpus = 2
        vb.memory = 2048
        vb.customize ["modifyvm", :id, "--vram", "128"]
        vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]  
        vb.gui = true
    end

    (1..3).each do |i|
        config.vm.define "node-#{i}" do |node|
            node.vm.hostname = "node-#{i}"
            node.vm.network "public_network", ip: "172.17.35.10#{i}"
            node.vm.provision "shell", path: "init.sh"
        
        end
    end
end