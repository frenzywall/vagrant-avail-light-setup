Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8048"
    vb.cpus = 8
  end
  config.vm.network "forwarded_port", guest: 9933, host: 9933  # RPC endpoint
  config.vm.network "forwarded_port", guest: 9615, host: 9615  # Metrics endpoint
  config.vm.provision "shell", path: "setup_avail.sh"
end
