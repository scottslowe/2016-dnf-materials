#!/bin/bash

# Set eth1 to promiscuous mode
sudo ip link set eth1 promisc on

# Create the non-VLAN Docker network used in the demo
sudo docker network create -d macvlan \
--subnet=192.168.100.0/24 --gateway=192.168.100.1 \
-o parent=eth1 -o macvlan_mode=bridge net1

# Create the VLAN-backed Docker network used in the demo
sudo docker network create -d macvlan \
--subnet=192.168.150.0/24 --gateway=192.168.150.1 \
-o parent=eth1.50 -o macvlan_mode=bridge net50

# Pull down the Docker Alpine image
sudo docker pull alpine:latest
