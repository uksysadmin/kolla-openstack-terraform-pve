# kolla-openstack-terraform-pve
Kolla-Ansible OpenStack using Terraform and Proxmox VE


Opinionated deployment of Kolla-Ansible to Proxmox VE using Terraform (or OpenTofu) and Ansible

Kevin Jackson
--
Prereqs
- Terraform or OpenTofu Installed
- Proxmox VE 3.x
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
8. scp -r ansible root@controller-01:
9. ssh controller-01
10. apt install ansible-common
11. ssh-keyscan -H controller-01 >> ~/.ssh/known_hosts
12. ssh-keyscan -H localhost >> ~/.ssh/known_hosts
13. ansible-playbook ansible/kolla-host-setup.yaml -i inventory.ini
14. ssh-keyscan -H compute-01 >> ~/.ssh/known_hosts
15. ssh-keyscan -H compute-02 >> ~/.ssh/known_hosts
16. ansible-playbook ansible/kolla-install-openstack.yaml -i /etc/kolla/inventory.ini
