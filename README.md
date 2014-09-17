# Mycel Client Vagrant Setup

This repo contains a SaltStack and vagrant setup to create a live image for Mycel Public Computers.
Basically it sets up a Lubuntu virtual box and initiates the necessary states to get the library PC
up and running.

It also contains a state to generate a live .ISO image

## Setup

You'll need Vagrant >= 1.5 (http://vagrantup.com)
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

`make deploy`      # deploy image to one or more locations

Setup deploy targets in pillar/admin.sls. Uses ssh to move previous image to archive and 
scp to copy new image and md5 checksum to deploy location.

## Cleanup
`make clean`       # destroy and delete VirtualBox
