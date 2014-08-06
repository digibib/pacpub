all: reload provision

reload: halt up

halt: 
	vagrant halt

up: 
	vagrant up

provision: 
	vagrant ssh -c 'sudo salt-call --local state.highstate'

upgrade: 
	vagrant ssh -c 'sudo salt-call --local state.sls pacpub.upgrade'

freeze: 
	vagrant ssh -c 'sudo salt-call --local state.sls pacpub.save_kioskstate'

iso: 
	vagrant ssh -c 'sudo salt-call --local state.sls pacpub.build_iso'

clean: 
	vagrant destroy --force