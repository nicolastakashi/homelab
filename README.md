# Homelab

This repository contains my homelab configuration files, scripts, and some documentation on how to set up and configure the services I use.

> [!WARNING]  
> This is a very opinionated setup and might not be suitable for everyone, but I hope it’s useful for someone looking for inspiration.

## Hardware

- **CPU:** AMD Ryzen 5 3600  
- **Memory:** 48GB RAM  
- **Storage:** 512GB NVMe  

## Software

- **Hypervisor:** Proxmox  
- **Orchestration:** Kubernetes (using k3s)  

## Why Do I Have a Homelab?

I’m a curious person who loves learning new things. A homelab gives me the freedom to experiment with different technologies and services without the fear of breaking anything critical.

I mainly use my homelab for:  
- Hosting observability tools  
- Running Kubernetes experiments  
- Hosting personal projects  

It’s a playground where I can explore, build, and learn at my own pace.

## Requirements

This setup is highly opinionated and may not fit everyone’s needs. That said, if you’re interested in trying it out, here’s what you’ll need:

- [Kubernetes](https://k3s.io/) - I'm using k3s
- [Helm](https://helm.sh/) - for managing Kubernetes applications
- [yq](https://github.com/mikefarah/yq) for YAML processing

## Setup

After getting your Kubernetes cluster up and running, you can initialize the basic setup with the following steps:

1. Expose `API_SERVER_IP` and `API_SERVER_PORT` environment variables in your shell, like so:

```bash
export API_SERVER_IP=123.456.78.910
export API_SERVER_PORT=6443
```

2. Run the following command to set up the cluster:

```bash
make setup
```

## References
- [Bootstrapping K3s with Cilium](https://docs.cilium.io/en/v1.10/gettingstarted/k3s/#bootstrapping-k3s-with-cilium) by [@vehagn](https://github.com/vehagn)