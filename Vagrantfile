
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"


  config.vm.network "forwarded_port", guest: 3306, host: 33306, host_ip: "127.0.0.1"
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder ".", "/home/vagrant/home"
  config.vm.provision :shell, :path => "./setup.sh", :args => "pass"

end
