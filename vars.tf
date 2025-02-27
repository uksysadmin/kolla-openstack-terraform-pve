variable "ssh_key" {
  default = "add_your_key_here"
}

variable "proxmox_host" {
    default = "pve.address.of_proxmox"
}

variable "proxmox_api_token_id" {
    default = "id@pam!token_name"
}

variable "pve_node" {
    default = "pve"
}

variable "proxmox_api_token_secret" {
    default = "secret_id"
}

variable "template_name" {
    default = "ubuntu-jammy-template"
}
