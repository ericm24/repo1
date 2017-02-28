#/bin/bash
#
# Script to customize docker-vm. 
# This script MUST reside in the directory:  /var/lib/boot2docker 
#

# set -x

sudo mkdir /mnt/dockervolumes
sudo mount -t vboxsf dockervolumes /mnt/dockervolumes




