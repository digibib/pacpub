DATE=`date +'%Y-%m-%d'`
SETTINGS='pillar/admin.sls'
DEPLOY_SSH=$(shell cat $(SETTINGS) | grep deploy_ssh | cut -d' ' -f2)
DEPLOY_IMGDIR=$(shell cat $(SETTINGS) | grep deploy_imgdir | cut -d' ' -f2)
DEPLOY_OLDDIR=$(shell cat $(SETTINGS) | grep deploy_olddir | cut -d' ' -f2)

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

deploy:
	# Generate md5 checksum
	echo "md5=$(shell md5sum mycelimage-newest.iso | cut -d' ' -f1)" > mycelimage-newest.md5
	# Move old .iso to archive
	ssh -oStrictHostKeyChecking=no -t $(DEPLOY_SSH) sudo mv $(DEPLOY_IMGDIR)/mycelimage-newest.iso $(DEPLOY_OLDDIR)/mycelimage-$(DATE).iso
	# Copy to deployment server
	scp -oStrictHostKeyChecking=no mycelimage-newest.* $(DEPLOY_SSH):/tmp
	ssh -oStrictHostKeyChecking=no -t $(DEPLOY_SSH) sudo mv /tmp/mycelimage-newest.* $(DEPLOY_IMGDIR) && rm /tmp/mycelimage*


deploy_pacman:
	echo "md5=$(shell md5sum mycelimage-newest.iso | cut -d' ' -f1)" > mycelimage-newest.md5
	cp mycelimage-newest.* ../pacman/
