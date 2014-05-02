#!/bin/sh

set -e

STARTDIR=`pwd`

/tmp/shape/bin/shape-0.0.0 stop || echo "No previous node running."
rm -rf /tmp/shape
rm -rf _rel

mkdir -p /tmp/shape

git checkout tags/v0.0.0
make release

cp _rel/shape-0.0.0.tar.gz /tmp/shape-0.0.0.tar.gz

cd /tmp/shape
tar xf /tmp/shape-0.0.0.tar.gz

echo "STARTING NODE"
./bin/shape-0.0.0 start

sleep 5s # let the system boot

./bin/shape-0.0.0 ping

# # # #

cd $STARTDIR

git checkout tags/v0.0.1
make relup

cp _rel/shape-0.0.1.tar.gz /tmp/shape-0.0.1.tar.gz

cd /tmp/shape
mkdir -p releases/0.0.1
cp /tmp/shape-0.0.1.tar.gz releases/0.0.1/shape.tar.gz

echo "UPGRADING NODE TO 0.0.1 (install)"
./bin/shape-0.0.0 install "0.0.1"

echo "DOWNGRADE NODE TO 0.0.0 (upgrade)"
./bin/shape-0.0.0 upgrade "0.0.0"

echo "UPGRADING NODE TO 0.0.1 (upgrade)"
./bin/shape-0.0.0 upgrade "0.0.1"

rm /tmp/shape-0.0.0.tar.gz
rm /tmp/shape-0.0.1.tar.gz

cd $STARTDIR
git checkout master
