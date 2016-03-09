#!/bin/bash

# Destroy and disable the default Libvirt network
sudo virsh net-destroy default
sudo virsh net-autostart --disable default

# Create a new network for macvtap devices
sudo virsh net-create macvtap.xml
sudo virsh net-start macvtap-net

# Set eth1 to promiscuous mode
sudo ip link set eth1 promisc on
