# Mycel Client Vagrant Setup

This repo contains a SaltStack and vagrant setup to create a live image for Mycel Public Computers.
Basically it sets up a Lubuntu virtual box and initiates the necessary states to get the library PC
up and running.

It also contains a state to generate a live .ISO image

## Setup

You'll need Vagrant >= 1.5 

    make

will do all the work on downloading a vagrant starter box and setup the packages needed.
First time run will take quite some time.

## Other states

    make upgrade

upgrades all packages in image

    make freeze

saves the kiosk state of the public user

    make iso

builds a live .ISO image from the current state and saves as mycelimage-newest.iso

See Makefile for more info on states
