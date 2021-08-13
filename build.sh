#! /bin/bash

sudo sysctl kernel.unprivileged_userns_clone=1

## This script is based on the instructions here : https://podman.io/getting-started/installation.html .   
export GOPATH=~/go
export GOCACHE="$(mktemp -d)"
export PATH=$GOPATH/bin:$PATH

mkdir -p $GOPATH
chmod -R 777 $GOPATH > /dev/null 2>&1
rm -rf $GOPATH > /dev/null 2>&1
if [[ -e $GOPATH ]] ; then
    echo unable to remove $GOPTATH
    exit 1
fi
mkdir -p $GOPATH

go get golang.org/x/tools/cmd/goimports

cd /tmp
# download policy.json
curl -L https://raw.githubusercontent.com/containers/skopeo/master/default-policy.json > policy.json

# download registries.conf and add localhost to search
curl -L https://raw.githubusercontent.com/projectatomic/registries/master/registries.fedora | \
    sed -e "/^registries/s='docker.io'='localhost', &=" > registries.conf

sudo mkdir -p /etc/containers
sudo cp registries.conf policy.json /etc/containers

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

mkdir -p ~/.config/containers
cat >> ~/.config/containers/storage.conf << EOF
[storage]
  driver = "overlay"

[storage.options.overlay]
mount_program = "/usr/bin/fuse-overlayfs"
EOF
