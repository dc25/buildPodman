#! /bin/bash

## This script is based on the instructions here : https://podman.io/getting-started/installation.html .   
export GOPATH=~/go
export GOCACHE="$(mktemp -d)"
export PATH=$GOPATH/bin:$PATH

mkdir -p $GOPATH
chmod -R 777 $GOPATH
rm -rf $GOPATH
mkdir -p $GOPATH

go get golang.org/x/tools/cmd/goimports

sudo mkdir -p /etc/containers
cd /etc/containers
sudo curl -L -o /etc/containers/registries.conf https://raw.githubusercontent.com/projectatomic/registries/master/registries.fedora
sudo curl -L -o /etc/containers/policy.json https://raw.githubusercontent.com/containers/skopeo/master/default-policy.json

cd $GOPATH
rm -rf conmon
git clone https://github.com/containers/conmon
cd conmon/
make
sudo make podman

rm -rf $GOPATH/src/github.com/containers/podman
mkdir -p $GOPATH/src/github.com/containers/podman
git clone https://github.com/containers/podman/ $GOPATH/src/github.com/containers/podman
cd $GOPATH/src/github.com/containers/podman
# git checkout `git rev-list -n 1 --first-parent --before="2021-01-13" master`
make BUILDTAGS="selinux seccomp"
sudo make install PREFIX=/usr
