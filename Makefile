DATE=`date +'%Y-%m-%d'`
SETTINGS='pillar/admin.sls'
SSH_OPTS=-oStrictHostKeyChecking=no -oPreferredAuthentications="password"
DEPLOYSERVER ?= melville.deichman.no
#DEPLOY_SSH=$(shell cat $(SETTINGS) | grep deploy_ssh | cut -d' ' -f2)
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

dist-upgrade:
	vagrant ssh -c 'sudo salt-call --local state.sls pacpub.dist-upgrade'

freeze: 
	vagrant ssh -c 'sudo salt-call --local state.sls pacpub.save_kioskstate'

iso: 
	vagrant ssh -c 'sudo salt-call --local state.sls pacpub.build_iso'

clean: 
	vagrant destroy --force


deploy_local:
	echo "md5=$(shell md5sum mycelimage-newest.iso | cut -d' ' -f1)" > mycelimage-newest.md5
	cp mycelimage-newest.* ../pacman/

deploy_server:
	# Generate md5 checksum
	echo "md5=$(shell md5sum mycelimage-newest.iso | cut -d' ' -f1)" > mycelimage-newest.md5
	# Copy to deployment server
	scp -r $(SSH_OPTS) mycelimage-newest.* $(SUDOUSER)@$(DEPLOYSERVER):/tmp/
	
	# Move old .iso to archive and new iso to deploy dir
	ssh $(SSH_OPTS) -t $(SUDOUSER)@$(DEPLOYSERVER) "sudo sh -c ' \
		sudo mv $(DEPLOY_IMGDIR)/mycelimage-newest.iso $(DEPLOY_OLDDIR)/mycelimage-$(DATE).iso || true && \
		sudo mv /tmp/mycelimage-newest.* $(DEPLOY_IMGDIR) && sudo clientserver.sh restart'"
