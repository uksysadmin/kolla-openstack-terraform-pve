# kolla-openstack-terraform-pve
Kolla-Ansible OpenStack using Terraform and Proxmox VE


Opinionated deployment of Kolla-Ansible to Proxmox VE using Terraform (or OpenTofu) and Ansible

Kevin Jackson
--
Prereqs
- Terraform or OpenTofu Installed
- Proxmox VE 8.x
- API User and Token created on Proxmox for Terraform

Proxmox Networking
- vmbr0 is your LAN bridge, default 192.168.68/22
- vmbr17 is the OpenStack Internal Networking, default 10.17.0.0/24
- vmbr20 is the OpenStack External FloatingIP Interface, default 10.0.20.0/24


1. Git Clone this repo
2. Edit ansible/files: hosts and hosts.debian.tmpl
3. Edit vars.tf
4. Check main.tf networking and image name, and sizing of VMs
5. tofu init
6. tofu plan -out "kolla-ansible.tfplan"
7. tofu apply "kolla-ansible.tfplan"
8. ansible-playbook ansible/install-kolla.yaml -i inventory.ini

--
# Apt-Cacher Configuration
You can use apt-cacher-ng if available by editig ansible/config.yaml

--
# Post Install
Run example runinit-once script matching the environments Floating IP Network

```
ssh ubuntu@controller-01
source /opt/kolla/bin/activate

cp /etc/kolla/clouds.yaml /etc/openstack

export EXT_NET_CIDR=10.0.20.0/24
export EXT_NET_RANGE='start=10.0.20.10,end=10.0.20.99'
export EXT_NET_GATEWAY=10.0.20.1

/opt/kolla/share/kolla-ansible/init-runonce
```

Create example Virtual Machine

```
openstack --os-cloud=kolla-admin server create \
    --image cirros \
    --flavor m1.tiny \
    --key-name mykey \
    --network demo-net \
    demo1
```

---
# Horizon
Horizon available @ http://192.168.70.10/

# Skyline
SKyline available @ http://192.168.70.10:9999/

Use the credentials found in /etc/kolla/admin-openrc.sh
