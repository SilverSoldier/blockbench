#!/bin/bash
# installing hyperledger-fabric with docker 

cd `dirname ${BASH_SOURCE-$0}`
. env.sh

sudo cp docker /etc/default/
sudo service docker restart
sudo apt-get install -y libsnappy-dev zlib1g-dev libbz2-dev

ARCH=`uname -m`
if [ $ARCH == "aarch64" ]; then
        ARCH="arm64"
elif [ $ARCH == "x86_64" ]; then
        ARCH="amd64"
fi

if ! [ -d "$HL_DATA" ]; then
	mkdir -p $HL_DATA
fi
cd $HL_DATA

GOTAR="go1.11.13.linux-$ARCH.tar.gz"
wget https://storage.googleapis.com/golang/$GOTAR
tar -zxvf $GOTAR
export GOPATH=`pwd`/go
export PATH=$PATH:`pwd`/go/bin

git clone https://github.com/facebook/rocksdb.git
cd rocksdb
git checkout v6.2.4
PORTABLE=1 make shared_lib
sudo INSTALL_PATH=/usr/local make install-shared

cd $HL_DATA/go
mkdir -p src/github.com/hyperledger
cd src/github.com/hyperledger
if [ $ARCH == "arm64" ]; then
	git clone https://github.com/dloghin/fabric.git
	cd fabric
	git checkout v0.6_blockbench
else
	git clone https://github.com/hyperledger/fabric
	cd fabric
	git checkout release-1.4
fi
cp $HL_HOME/hl_core.yaml peer/core.yaml
make peer
