#!/bin/bash

# Launch VM based on the downloaded CirrOS disk image
virt-install --name=cirros --ram=256 --vcpus=1 \
--disk path=./cirros-0.3.2-x86_64-disk.img,format=qcow2 \
--import --network network:macvtap-net,model=virtio --vnc
