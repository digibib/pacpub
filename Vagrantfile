# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'

pillar_admin_file = 'pillar/admin.sls';
 
if !File.file?(pillar_admin_file)
  puts "Copying #{pillar_admin_file} from example..."
  FileUtils.cp("#{pillar_admin_file}.example", pillar_admin_file);
else
  puts "Found existing #{pillar_admin_file}."
end

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "mast3rof0/lubuntu32"
  config.vm.box_url ="http://datatest.deichman.no/vagrant/lubuntu_14041_32b.box"
  
  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    vb.gui = true
    # Use VBoxManage to customize the VM. For example to change memory:
    # vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.synced_folder ".", "/srv"


  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
    #salt.always_install = true
    #salt.bootstrap_options = "-g https://github.com/saltstack/salt.git"
    #salt.install_args = " v2014.7"
    #salt.install_type = "git"
    #salt.verbose = true
    #salt.pillar_data
  end
end
