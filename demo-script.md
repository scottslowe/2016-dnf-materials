---
title:              DNF Demo Script  
project:            DevOps Network Forum 2016  
author:             Scott Lowe  
affiliation:        VMware, Inc.  
date:               2016-03-10  
keywords:           Linux, Networking, VLAN, CLI, KVM, Docker  
---

# [%title]

## Demo: VLAN interfaces

_Prep:_

* Run `vagrant up remote-01` to create and provision remote target VM.
* On `remote-01`, run `remote-setup.sh` to create the namespace and VLAN interface.
* Run `vagrant up ns-01` to create and provision demo VM.
* Run `source ns-aliases` to get aliases for demo.
* Have a terminal window open to `ns-01`.

_Demo:_

1. Show terminal window for `ns-01`.
2. Run `ip link list` to show current interfaces (only loopback & physical interfaces are listed).
3. Run `ip link add link eth1 eth1.50 type vlan id 50` to create VLAN interface.
4. Run `ip addr add 192.168.150.102/24 dev eth1.50` to add IP address to VLAN interface.
5. Run `ip link set eth1.50 up` to activate VLAN interface.
6. Run `ping -c 4 192.168.150.110` to ping remote target VM.
7. Delete the VLAN interface with `ip link del eth1.50`.

## Demo: Network namespaces

_Prep:_

* Run `vagrant up ns-01` to create and provision demo VM.
* Run `source ns-aliases` to get aliases for demo.
* Have terminal window open to `ns-01`.

_Demo:_

1. Run `ip netns list` to show no non-default namespaces (output is empty).
2. Run `ip netns add ns1` to create namespace named "ns1".
3. Run `ip link add link eth1 eth1.50 type vlan id 50` to create VLAN interface, then run `ip -d link list` to show new interface.
4. Run `ip link set eth1.50 netns ns1` to move VLAN interface to namespace.
5. Run `ip link list` to show VLAN interface is now gone from default namespace.
6. Run `shellns1` to open a shell in the "ns1" namespace.
7. Run `ip addr add 192.168.150.102/24 dev eth1.50` to plumb an IP address in the namespace.
8. Run `ip link set eth1.50 up` to turn up the interface in the namespace.
9. Run `ping -c 4 192.168.150.110` to remote target VM.
10. Exit out of namespace.
11. Repeat step 11; it will fail (no route to host).

## Demo: veth (Virtual Ethernet) interfaces

_Prep:_

* Run `vagrant up docker-01` to create and provision Docker VM for demo.
* Run `docker pull alpine:latest` to pull down container image for demo.
* Have 2 terminal windows open to `docker-01`.

_Demo:_

1. Run `docker ps` to show there are no running containers.
2. Run `ip link list` to show the current adapters (only loopback, physical, and default Docker bridge are listed).
3. Run `docker run -it --name=veth --rm alpine /bin/sh` to launch container.
4. In container, run `ip addr list` to show interfaces and addresses. Point out interface index.
5. In second terminal window, run `ip link list` to show new interface.
6. In second terminal window, run `ip -d link list <name>` to show new interface is a veth interface.
7. Run `ethtool -S <name>` to show interface index of peer, which will match interface index from step #4.

## Demo: KVM with macvtap adapters

_Prep:_

* Run `vagrant up kvm-01` to create and provision KVM VM for demo.
* On `kvm-01`, run `kvm-setup.sh` to create macvtap-based Libvirt network.
* Have 1 terminal window open to `kvm-01`.

_Demo:_

1. Show terminal window for `kvm-01`.
2. Run `ip link list` to show current interfaces (only loopback & physical interfaces are listed).
3. Run `sudo lsmod | grep macvlan` to show the macvlan kernel module is not loaded.
4. Run `launch-vm.sh` to launch the CirrOS-based VM (only first time after KVM VM is created; otherwise run `sudo virsh start cirros`).
5. Run `ip link list` to show new interface.
6. Run `sudo ip -d link list macvtap0` to show new interface is, in fact, a macvtap interface.
7. Run `sudo lsmod | grep macvlan` to show macvlan kernel module being used by macvtap interface.

## Demo: Docker with macvlan interfaces

_Prep:_

* Run `vagrant up docker-01` to create and provision Docker VM for demo (may need to log into Docker VM to fix Ansible playbook error).
* Run `docker-setup.sh` to create necessary Docker networks and pull Docker images.
* Have 3 terminal windows open to `docker-01`.

_Demo:_

1. Show first terminal window for `docker-01`.
2. Run `ip link list` to show current interfaces (only loopback, physical interfaces, and default Docker bridge are listed).
3. Run `docker ps` to show no Docker containers are running.
4. Run `docker run --net=net1 -it --name=demo1 --rm alpine /bin/sh` to launch Alpine container.
5. From Alpine container prompt, run `ip link list`, point out interface name in container.
6. From Alpine container prompt, run `ping -c 4 192.168.100.100` (IP address associated with KVM host) to show connectivity.
7. Switch to second terminal window for `docker-01`.
8. Run `docker run --net=net50 -it --name=demo2 --rm alpine /bin/sh` to launch Alpine container.
9. From Alpine container prompt, run `ip link list`, point out interface name in container.
10. From Alpine container prompt, run `ip addr list` and make note of address.
11. Switch to third terminal window for `docker-01`.
12. Run `ip link list` and point out new VLAN interface. Draw correlation between interface index and name of interface in container.
13. Run `sudo ip -d link list eth1.50` to show new interface is a VLAN interface.
