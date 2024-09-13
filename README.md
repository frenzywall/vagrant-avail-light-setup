# Avail Light Client Setup


## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads) installed on my local machine.
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) or another compatible provider for Vagrant.

**To run this : use Vagrant up in the root directory.
## Vagrant Configuration

1. **Create a `Vagrantfile`**: This file defines the configuration the Vagrant environment, including the box to use, network settings, and provisioning scripts.

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "8048"
    vb.cpus = 8
  end

  config.vm.network "forwarded_port", guest: 9933, host: 9933  # RPC endpoint
  config.vm.network "forwarded_port", guest: 9615, host: 9615  # Metrics endpoint

  # Provisioning
  config.vm.provision "shell", path: "setup_avail.sh"
end
# Avail Light Client Setup



Create and Configure Vagrant Environment:

- Save the provided Vagrant configuration to a file named `Vagrantfile` in your project directory.
- Save the provided Bash script to a file named `setup_avail.sh` in the same directory.

Initialize and Provision Vagrant:

- Open a terminal and navigate to the directory containing your `Vagrantfile` and `setup_avail.sh`.
- Run `vagrant up` to create and provision the virtual machine according to the configuration.

Check Service Status:

- Once provisioning is complete, you can SSH into the Vagrant machine using `vagrant ssh`.
- Check the status of the Avail Light Client service with `sudo systemctl status avail-light-client`.

Test the RPC Endpoint:

- From within the Vagrant machine, test the RPC endpoint by running `curl http://localhost:9933`.
- Test the metrics endpoint by running `curl http://localhost:9615/metrics`.


