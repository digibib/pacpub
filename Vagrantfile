# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'fileutils'

SALT_VERSION="2015.5.2+ds-1utopic1"

pillar_admin_file = 'pillar/admin.sls';
 
if !File.file?(pillar_admin_file)
  puts "Copying #{pillar_admin_file} from example..."
  FileUtils.cp("#{pillar_admin_file}.example", pillar_admin_file);
else
  puts "Found existing #{pillar_admin_file}."
end

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "pacpub"
  config.vm.box_url ="http://datatest.deichman.no/vagrant/lubuntu-14.04-20160113-i386.box"
  
  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    vb.gui = true
    # Use VBoxManage to customize the VM. For example to change memory:
    # vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.synced_folder ".", "/srv"

  #config.vm.provision "shell", inline: "sudo add-apt-repository -y ppa:saltstack/salt && \
  #  sudo apt-get update && \
  #  sudo apt-get install -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confold salt-minion=\"#{SALT_VERSION}\" salt-master=\"#{SALT_VERSION}\""

  config.vm.provision :salt do |salt|
    #salt.bootstrap_options = "-F -c /tmp -P"  # Vagrant Issues #6011, #6029
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
    salt.verbose = true
  end

end
