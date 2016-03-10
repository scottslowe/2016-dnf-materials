#!/bin/bash

# Create a network namespace for VLAN 50
sudo ip netns add vlan50

# Create and configure a VLAN interface for VLAN 50
sudo ip link add link eth1 eth1.50 type vlan id 50
sudo ip link set eth1.50 netns vlan50
sudo ip netns exec vlan50 ip addr add 192.168.150.110/24 dev eth1.50
sudo ip netns exec vlan50 ip link set eth1.50 up
