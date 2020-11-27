#! /bin/bash
sudo apt install -y   make curl
sudo apt install -y   libapparmor-dev
sudo apt install -y libprotobuf-c-dev btrfs-progs 
sudo apt install -y git   golang-go   go-md2man   iptables   libassuan-dev   libbtrfs-dev   libc6-dev   libdevmapper-dev   libglib2.0-dev   libgpgme-dev   libgpg-error-dev   libprotobuf-dev    libseccomp-dev   libselinux1-dev   libsystemd-dev   pkg-config   runc   uidmap

export GOPATH=~/go
export GOCACHE="$(mktemp -d)"
mkdir -p $GOPATH

sudo mkdir -p /etc/containers
cd /etc/containers
sudo curl -L -o /etc/containers/registries.conf https://raw.githubusercontent.com/projectatomic/registries/master/registries.fedora
sudo curl -L -o /etc/containers/policy.json https://raw.githubusercontent.com/containers/skopeo/master/default-policy.json

cd $GOPATH
git clone https://github.com/containers/conmon
cd conmon/
make
sudo make podman

mkdir -p $GOPATH/src/github.com/containers/podman
git clone https://github.com/containers/podman/ $GOPATH/src/github.com/containers/podman
cd $GOPATH/src/github.com/containers/podman
make BUILDTAGS="selinux seccomp"
sudo make install PREFIX=/usr
