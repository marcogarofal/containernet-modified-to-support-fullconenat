# Containernet

<img align="left" width="200" height="200" style="margin: 30px 30px 0 0;" src="/assets/logo.png" />

Containernet is a fork of the famous [Mininet](http://mininet.org) network emulator and allows to use [Docker](https://www.docker.com) containers as hosts in emulated network topologies. This enables interesting functionalities to build networking/cloud emulators and testbeds. Containernet is actively used by the research community, focussing on experiments in the field of cloud computing, fog computing, network function virtualization (NFV) and multi-access edge computing (MEC). One example for this is the [NFV multi-PoP infrastructure emulator](https://github.com/sonata-nfv/son-emu) which was created by the SONATA-NFV project and is now part of the [OpenSource MANO (OSM)](https://osm.etsi.org) project.

## Features

- Add, remove Docker containers to Mininet topologies
- Connect Docker containers to topology (to switches, other containers, or legacy Mininet hosts)
- Execute commands inside containers by using the Mininet CLI
- Dynamic topology changes
  - Add hosts/containers to a _running_ Mininet topology
  - Connect hosts/docker containers to a _running_ Mininet topology
  - Remove Hosts/Docker containers/links from a _running_ Mininet topology
- Resource limitation of Docker containers
  - CPU limitation with Docker CPU share option
  - CPU limitation with Docker CFS period/quota options
  - Memory/swap limitation
  - Change CPU/mem limitations at runtime!
- Expose container ports and set environment variables of containers through Python API
- Traffic control links (delay, bw, loss, jitter)
- Automated installation based on Ansible playbook

## Installation

### Nested Docker deployment

Containernet can be executed within a privileged Docker container (nested container deployment). There is also a pre-build Docker image available on [Docker Hub](https://hub.docker.com/r/containernet/containernet/).

**Attention:** Container resource limitations, e.g. CPU share limits, are not supported in the nested container deployment. Use bare-metal installations if you need those features.

You can build the container locally:

```bash
docker build -t containernet2/containernet2 . 
```

You can then directly start the default containernet example:

```bash
docker run --name containernet -it --rm --privileged --pid='host' -v /var/run/docker.sock:/var/run/docker.sock containernet2/containernet2
```

or run an interactive container and drop to the shell:

```bash
docker run --name containernet -it --rm --privileged --pid='host' -v /var/run/docker.sock:/var/run/docker.sock containernet2/containernet2 /bin/bash
```

```bash
sudo docker run --name containernet -it --rm --privileged --pid='host' -v /var/run/docker.sock:/var/run/docker.sock --cap-add=ALL -d -v /dev:/dev -v /lib/modules:/lib/modules containernet2/containernet2 /bin/bash
```



## Get started

Using Containernet is very similar to using Mininet.



### Customizing topologies

You can also add hosts with resource restrictions or mounted volumes:

```python
# ...

d1 = net.addDocker('d1', ip='10.0.0.251', dimage="ubuntu:trusty")
d2 = net.addDocker('d2', ip='10.0.0.252', dimage="ubuntu:trusty", cpu_period=50000, cpu_quota=25000)
d3 = net.addHost('d3', ip='11.0.0.253', cls=Docker, dimage="ubuntu:trusty", cpu_shares=20)
d4 = net.addDocker('d4', dimage="ubuntu:trusty", volumes=["/:/mnt/vol1:rw"])

# ...
```
