Vagrant.configure(2) do |config|
  config.vm.box = "centos/8"

 config.vm.define "repository" do |repository|
 repository.vm.hostname = "repository"
 repository.vm.provision "shell", path: "configure.sh"  end

 end
