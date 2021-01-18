#! /bin/bash

## This script is based on the instructions here : https://podman.io/getting-started/installation.html .   
sudo apt install -y   make curl
sudo apt install -y   libapparmor-dev
sudo apt install -y libprotobuf-c-dev btrfs-progs 

# sudo apt install -y \
#   golang-go   \
#   go-md2man   

sudo apt install -y \
  git   \
  iptables   \
  libassuan-dev   \
  libbtrfs-dev   \
  libc6-dev   \
  libdevmapper-dev   \
  libglib2.0-dev   \
  libgpgme-dev   \
  libgpg-error-dev   \
  libprotobuf-dev    \
  libseccomp-dev   \
  libselinux1-dev   \
  libsystemd-dev   \
  pkg-config   \
  runc   \
  uidmap

sudo apt install -y slirp4netns
sudo apt install -y fuse-overlayfs
