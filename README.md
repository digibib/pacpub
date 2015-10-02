# Mycel Client Vagrant Setup

This repo contains a SaltStack and vagrant setup to create a live image for Mycel Public Computers.
Basically it sets up a Lubuntu virtual box and initiates the necessary states to get the library PC
up and running.

It also contains a state to generate a live .ISO image

## Setup

You'll need Vagrant >= 1.5 (http://vagrantup.com)

You'll also need virtualbox, git and make:

`sudo apt-get install virtualbox git make`

Local settings are set in `pillar/admin.sls` with a default at `pillar/admin.sls.example`

    make

will do all the work on downloading a vagrant starter box and setup the packages and states needed.
First time run will take quite some time.

## Usage

`make provision`   # run highstate. set box in states form salt/top.sls
`make upgrade`     # upgrades all packages in image
`make freeze`      # saves the kiosk state of the public user

## Build and deploy

`make iso`         # builds a live .ISO image from the current state 

Live ISO is generated and saved in current folder as mycelimage-newest.iso

## Test Deploy

For testing generated image locally, deploy to local pacman first. (expects parent dir to be ../pacman)

`make deploy_local`

which assumes pacman is installed in subdirectory.
(http://github.com/digibib/pacman.git)
(To deploy testimage to pacman client, use `make import_iso` inside pacman)

## Deploy

For production deploy, make sure to setup deploy targets in pillar/admin.sls. 

`SUDOUSER=user DEPLOYSERVER=example.com make deploy_server`      # deploy image to one or more locations using a user with sudo privileges on server.

Uses ssh to move previous image to archive and  scp to copy new image and md5 checksum to deploy location.

## Cleanup
`make clean`       # destroy and delete VirtualBox
