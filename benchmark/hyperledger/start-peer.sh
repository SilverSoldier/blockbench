#!/bin/bash
PEERID=$1

cd `dirname ${BASH_SOURCE-$0}`
. env.sh

PEER="$HL_SOURCE/build/bin/peer"
if ! [ -e $PEER ]; then
	echo "Hyperledger peer executable not found: $PEER"
	exit 1
fi

export CORE_PEER_ID=vp$PEERID
CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052
export CORE_PEER_NETWORKID=dev2
export CORE_PEER_FILE_SYSTEM_PATH=/tmp/hyperledger
export CORE_VM_ENDPOINT=http://0.0.0.0:2375

rm -rf $CORE_PEER_FILE_SYSTEM_PATH
mkdir -p $CORE_PEER_FILE_SYSTEM_PATH
mkdir -p $LOG_DIR

# GO env
export GOPATH=$HL_DATA/go
export PATH=$PATH:$HL_DATA/go/bin

# rocksdb lib
export LD_LIBRARY_PATH=/usr/local/lib

HOST=`hostname`
nohup $PEER node start > $LOG_DIR/hl_log_slave_$HOST 2>&1 &

